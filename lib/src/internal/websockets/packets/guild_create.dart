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
import 'package:mineral/src/api/managers/voice_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
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
    MineralClient client = ioc.singleton(ioc.services.client);

    GuildRoleManager roleManager = GuildRoleManager(guildId: websocketResponse.payload['id']);
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    Map<Snowflake, VoiceManager> voices = {};
    for(dynamic voiceMember in websocketResponse.payload['voice_states']) {
      final VoiceManager voiceManager = VoiceManager.from(voiceMember, null);
      voices.putIfAbsent(voiceMember['user_id'], () => voiceManager);
      voices.putIfAbsent(voiceMember['channel_id'], () => voiceManager);
    }

    MemberManager memberManager = MemberManager(guildId: websocketResponse.payload['id']);
    for (dynamic member in websocketResponse.payload['members']) {
      User user = User.from(member['user']);

      GuildMember guildMember = GuildMember.from(
        roles: roleManager,
        user: user,
        member: member,
        guildId: websocketResponse.payload['id'],
        voice: voices.containsKey(user.id)
            ? voices.get(user.id)!
            : VoiceManager(
                isMute: member['mute'],
                isDeaf: member['deaf'],
                isSelfMute: false,
                isSelfDeaf: false,
                hasVideo: false,
                hasStream: false,
                channel: null
            )
      );

      memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
      client.users.cache.putIfAbsent(user.id, () => user);
    }

    ChannelManager channelManager = ChannelManager(guildId: websocketResponse.payload['id']);
    for(dynamic payload in websocketResponse.payload['channels']) {
      ChannelType channelType = ChannelType.values.firstWhere((type) => type.value == payload['type']);
      if (channels.containsKey(channelType)) {
        Channel Function(dynamic payload) item = channels[channelType] as Channel Function(dynamic payload);
        Channel channel = item(payload);

        channelManager.cache.putIfAbsent(channel.id, () => channel);
      }
    }

    EmojiManager emojiManager = EmojiManager(guildId: websocketResponse.payload['id']);
    for(dynamic payload in websocketResponse.payload['emojis']) {
      Emoji emoji = Emoji.from(
        memberManager: memberManager,
        emojiManager: emojiManager,
        payload: payload
      );

      emojiManager.cache.putIfAbsent(emoji.id, () => emoji);
    }

    GuildScheduledEventManager guildScheduledManager = GuildScheduledEventManager(guildId: websocketResponse.payload['id']);
    for(dynamic payload in websocketResponse.payload['guild_scheduled_events']) {
      GuildScheduledEvent event = GuildScheduledEvent.from(
        channelManager: channelManager,
        memberManager: memberManager,
        payload: payload
      );

      guildScheduledManager.cache.putIfAbsent(event.id, () => event);
    }

    ModerationRuleManager moderationManager = ModerationRuleManager(guildId: websocketResponse.payload['id']);

    WebhookManager webhookManager = WebhookManager(guildId: websocketResponse.payload['id']);

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

    // Assign guild members
    guild.members.cache.forEach((Snowflake id, GuildMember member) {
      member.guild = guild;
      member.voice.member = member;
    });

    // Assign guild channels
    channelManager.guild = guild;
    guild.channels.cache.forEach((Snowflake id, Channel channel) {
      channel.guildId = guild.id;
      channel.guild = guild;
      channel.parent = channel.parentId != null ? guild.channels.cache.get<CategoryChannel>(channel.parentId) : null;
      channel.webhooks.guild = guild;
      channel.permissionOverwrites?.guildId = guild.id;

      if(voices.containsKey(id)) {
        voices.get(id)!.channel = channel as VoiceChannel;
      }
    });

    moderationManager.guild = guild;

    guild.stickers.guild = guild;
    guild.stickers.cache.forEach((_, sticker) {
      sticker.guild = guild;
      sticker.guildMember = guild.channels.cache.get(sticker.guildMemberId);
    });

    guild.afkChannel = guild.channels.cache.get<VoiceChannel>(guild.afkChannelId);
    guild.systemChannel = guild.channels.cache.get<TextChannel>(guild.systemChannelId);
    guild.rulesChannel = guild.channels.cache.get<TextChannel>(guild.rulesChannelId);
    guild.publicUpdatesChannel = guild.channels.cache.get<TextChannel>(guild.publicUpdatesChannelId);
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
      commands: commandManager.getFromGuild(guild)
    );

    client.guilds.cache.putIfAbsent(guild.id, () => guild);

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
