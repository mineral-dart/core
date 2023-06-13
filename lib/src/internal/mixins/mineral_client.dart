import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/guild_scheduled_event_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/messages/message_parser.dart';
import 'package:mineral/src/api/sticker.dart';
import 'package:mineral_ioc/ioc.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (PartialChannel channel, { String? content, List<EmbedBuilder>? embeds, ComponentBuilder? components, List<AttachmentBuilder>? attachments, bool? tts, Map<String, Snowflake>? messageReference }) async {
    dynamic messagePayload = MessageParser(content, embeds, components, attachments, tts).toJson();

    return await ioc.use<DiscordApiHttpService>().post(url: "/channels/${channel.id}/messages")
      .files(messagePayload['files'])
      .payload({
        ...messagePayload['payload'],
        'message_reference': messageReference != null ? { ...messageReference, 'fail_if_not_exists': true } : null,
      })
      .build();
  }

  Future<T?> createChannel<T extends GuildChannel> (Snowflake guildId, ChannelBuilder builder) async {
    Response response = await ioc.use<DiscordApiHttpService>().post(url: "/guilds/$guildId/channels")
      .payload(builder.payload)
      .build();

    final payload = jsonDecode(response.body);

    final channel = ChannelWrapper.create(payload);
    return channel as T?;
  }

  Future<Guild> makeGuild (MineralClient client, dynamic payload) async {
    MemberManager memberManager = MemberManager(payload['id']);
    ChannelManager channelManager = ChannelManager(payload['id']);
    GuildRoleManager roleManager = GuildRoleManager(payload['guild_id']);

    for (dynamic item in payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    Map<Snowflake, VoiceManager> voices = {};
    if (payload['voice_states'] != null) {
      for(dynamic voiceMember in payload['voice_states']) {
        final VoiceManager voiceManager = VoiceManager.from(voiceMember, payload['guild_id']);
        voices.putIfAbsent(voiceMember['user_id'], () => voiceManager);
      }
    }

    EmojiManager emojiManager = EmojiManager();
    for(dynamic payload in payload['emojis']) {
      Emoji emoji = Emoji.from(
        memberManager: memberManager,
        emojiManager: emojiManager,
        payload: payload
      );

      emojiManager.cache.putIfAbsent(emoji.id, () => emoji);
    }

    GuildScheduledEventService guildScheduledManager = GuildScheduledEventService();
    if (payload['guild_scheduled_events'] != null) {
      for(dynamic payload in payload['guild_scheduled_events']) {
        GuildScheduledEvent event = GuildScheduledEvent.from(
          channelManager: channelManager,
          memberManager: memberManager,
          payload: payload
        );

        guildScheduledManager.cache.putIfAbsent(event.id, () => event);
      }
    }

    ModerationRuleManager moderationManager = ModerationRuleManager(payload['guild_id']);

    WebhookManager webhookManager = WebhookManager(payload['id'], null);

    Guild guild = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
      moderationRuleManager: moderationManager,
      webhookManager: webhookManager,
      guildScheduledEventService: guildScheduledManager,
      payload: payload,
    );

    client.guilds.cache[guild.id] = guild;

    for (dynamic element in payload['stickers']) {
      Sticker sticker = Sticker.from(element);
      guild.stickers.cache.putIfAbsent(sticker.id, () => sticker);
    }

    if (payload['members'] != null) {
      for (dynamic member in payload['members']) {
        User user = User.from(member['user']);
        GuildMember guildMember = GuildMember.from(
          roles: roleManager,
          user: user,
          member: member,
          guild: guild,
          voice: voices.containsKey(user.id)
            ? voices.get(user.id)!
            : VoiceManager.empty(member['deaf'], member['mute'], user.id, payload['guild_id'])
        );

        memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
        client.users.cache.putIfAbsent(user.id, () => user);
      }
    }

    if (payload['channels'] != null) {
      for (final element in payload['channels']) {
        element['guild_id'] = payload['id'];
        final GuildChannel? channel = ChannelWrapper.create(element);

        if (channel != null) {
          channelManager.cache.putIfAbsent(channel.id, () => channel);
        }
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

    return guild;
  }

  Future<Map<Snowflake, ModerationRule>?> getAutoModerationRules (Guild guild) async {
    Response response = await container.use<DiscordApiHttpService>()
      .get(url: "/guilds/${guild.id}/auto-moderation/rules")
      .build();

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