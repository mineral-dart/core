import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_scheduled_event_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    CommandManager commandManager = ioc.singleton(ioc.services.command);
    ContextMenuManager contextMenuManager = ioc.singleton(ioc.services.contextMenu);
    MineralClient client = ioc.singleton(ioc.services.client);

    GuildRoleManager roleManager = GuildRoleManager();
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    Map<Snowflake, VoiceManager> voices = {};
    for(dynamic voiceMember in websocketResponse.payload['voice_states']) {
      final VoiceManager voiceManager = VoiceManager.from(voiceMember, null, null);

      voices.putIfAbsent(voiceMember['user_id'], () => voiceManager);
      voices.putIfAbsent(voiceMember['channel_id'], () => voiceManager);
    }

    MemberManager memberManager = MemberManager();
    ChannelManager channelManager = ChannelManager();

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

    ModerationRuleManager moderationManager = ModerationRuleManager();

    WebhookManager webhookManager = WebhookManager();

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

    for (dynamic member in websocketResponse.payload['members']) {
      User user = User.from(member['user']);
      GuildMember guildMember = GuildMember.from(
        roles: roleManager,
        user: user,
        member: member,
        guild: guild,
        voice: voices.containsKey(user.id)
          ? voices.get(user.id)!
          : VoiceManager(member['mute'], member['deaf'], false, false, false, false, null, null)
      );

      guildMember.voice.member = guildMember;

      memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
      client.users.cache.putIfAbsent(user.id, () => user);
    }

    for(dynamic payload in websocketResponse.payload['channels']) {
      ChannelType channelType = ChannelType.values.firstWhere((type) => type.value == payload['type']);
      if (channels.containsKey(channelType)) {
        Channel Function(Guild guild, dynamic payload) item = channels[channelType] as Channel Function(Guild guild, dynamic payload);
        Channel channel = item(guild, payload);

        channelManager.cache.putIfAbsent(channel.id, () => channel);
      }
    }

    // Assign guild channels
    guild.channels.cache.forEach((Snowflake id, Channel channel) {
      if(voices.containsKey(id)) {
        voices.getOrFail(id).channel = channel as VoiceChannel;
      }
    });

    guild.owner = memberManager.cache.getOrFail(websocketResponse.payload['owner_id']);
    guild.afkChannel = guild.channels.cache.get<VoiceChannel>(guild.afkChannelId);
    guild.systemChannel = guild.channels.cache.get<TextChannel>(guild.systemChannelId);
    guild.rulesChannel = guild.channels.cache.get<TextChannel>(guild.rulesChannelId);
    guild.publicUpdatesChannel = guild.channels.cache.get<TextChannel>(guild.publicUpdatesChannelId);
    guild.webhooks.guild = guild;
    guild.emojis.guild = guild;
    guild.roles.guild = guild;
    guild.scheduledEvents.guild = guild;
    guild.webhooks.guild = guild;

    Map<Snowflake, ModerationRule>? autoModerationRules = await getAutoModerationRules(guild);
    if (autoModerationRules != null) {
      guild.moderationRules.cache.addAll(autoModerationRules);
    }

    await client.registerGuildCommands(
      guild: guild,
      commands: commandManager.getFromGuild(guild),
      contextMenus: contextMenuManager.getFromGuild(guild)
    );

    manager.emit(
      event: Events.guildCreate,
      params: [guild]
    );
  }

  Future<Map<Snowflake, ModerationRule>?> getAutoModerationRules (Guild guild) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/guilds/${guild.id}/auto-moderation/rules");

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      Map<Snowflake, ModerationRule> rules = {};
      for (dynamic element in payload) {
        ModerationRule rule = ModerationRule.from(guild: guild, payload: element);
        rules.putIfAbsent(rule.id, () => rule);
      }

      return rules;
    }

    return null;
  }
}
