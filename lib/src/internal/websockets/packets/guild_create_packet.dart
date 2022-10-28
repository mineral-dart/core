import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_scheduled_event_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/sticker.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildCreatePacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    CommandManager commandManager = ioc.singleton(Service.command);
    // ContextMenuManager contextMenuManager = ioc.singleton(Service.contextMenu);
    MineralClient client = ioc.singleton(Service.client);

    websocketResponse.payload['guild_id'] = websocketResponse.payload['id'];

    GuildRoleManager roleManager = GuildRoleManager(websocketResponse.payload['guild_id']);
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    Map<Snowflake, VoiceManager> voices = {};
    for(dynamic voiceMember in websocketResponse.payload['voice_states']) {
      final VoiceManager voiceManager = VoiceManager.from(voiceMember, websocketResponse.payload['guild_id']);
      voices.putIfAbsent(voiceMember['user_id'], () => voiceManager);
    }

    MemberManager memberManager = MemberManager();
    ChannelManager channelManager = ChannelManager(websocketResponse.payload['id']);

    EmojiManager emojiManager = EmojiManager();
    for(dynamic payload in websocketResponse.payload['emojis']) {
      Emoji emoji = Emoji.from(
        memberManager: memberManager,
        emojiManager: emojiManager,
        payload: payload
      );

      emojiManager.cache.putIfAbsent(emoji.id, () => emoji);
    }

    GuildScheduledEventManager guildScheduledManager = GuildScheduledEventManager();
    for(dynamic payload in websocketResponse.payload['guild_scheduled_events']) {
      GuildScheduledEvent event = GuildScheduledEvent.from(
        channelManager: channelManager,
        memberManager: memberManager,
        payload: payload
      );

      guildScheduledManager.cache.putIfAbsent(event.id, () => event);
    }

    ModerationRuleManager moderationManager = ModerationRuleManager(websocketResponse.payload['guild_id']);

    WebhookManager webhookManager = WebhookManager(websocketResponse.payload['id'], null);

    Guild guild = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
      moderationRuleManager: moderationManager,
      webhookManager: webhookManager,
      guildScheduledEventManager: guildScheduledManager,
      payload: websocketResponse.payload,
    );

    client.guilds.cache.putIfAbsent(guild.id, () => guild);

    for (dynamic element in websocketResponse.payload['stickers']) {
      Sticker sticker = Sticker.from(element);
      guild.stickers.cache.putIfAbsent(sticker.id, () => sticker);
    }

    for (dynamic member in websocketResponse.payload['members']) {
      User user = User.from(member['user']);
      GuildMember guildMember = GuildMember.from(
        roles: roleManager,
        user: user,
        member: member,
        guild: guild,
        voice: voices.containsKey(user.id)
          ? voices.get(user.id)!
          : VoiceManager.empty(member['deaf'], member['mute'], user.id, websocketResponse.payload['guild_id'])
      );

      memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
      client.users.cache.putIfAbsent(user.id, () => user);
    }

    for(dynamic payload in websocketResponse.payload['channels']) {
      payload['guild_id'] = websocketResponse.payload['id'];
      final GuildChannel? channel = ChannelWrapper.create(payload);

      if (channel != null) {
        channelManager.cache.putIfAbsent(channel.id, () => channel);
      }
    }

    guild.afkChannel = guild.channels.cache.get<VoiceChannel>(guild.afkChannelId);
    guild.systemChannel = guild.channels.cache.get<TextChannel>(guild.systemChannelId);
    guild.rulesChannel = guild.channels.cache.get<TextChannel>(guild.rulesChannelId);
    guild.publicUpdatesChannel = guild.channels.cache.get<TextChannel>(guild.publicUpdatesChannelId);
    guild.webhooks.guild = guild;
    guild.emojis.guild = guild;
    guild.scheduledEvents.guild = guild;

    Map<Snowflake, ModerationRule>? autoModerationRules = await getAutoModerationRules(guild);
    if (autoModerationRules != null) {
      guild.moderationRules.cache.addAll(autoModerationRules);
    }

    await client.registerGuildCommands(
      guild: guild,
      commands: commandManager.getGuildCommands(guild),
      // contextMenus: contextMenuManager.getFromGuild(guild)
        contextMenus: []
    );

    eventManager.controller.add(GuildCreateEvent(guild));
  }

  Future<Map<Snowflake, ModerationRule>?> getAutoModerationRules (Guild guild) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.get(url: "/guilds/${guild.id}/auto-moderation/rules");

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      Map<Snowflake, ModerationRule> rules = {};
      for (dynamic element in payload) {
        ModerationRule rule = ModerationRule.fromPayload(element);
        rules.putIfAbsent(rule.id, () => rule);
      }

      return rules;
    }

    return null;
  }
}
