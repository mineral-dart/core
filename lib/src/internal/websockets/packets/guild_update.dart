import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/guild_role_manager.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_scheduled_event_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';


class GuildUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    Guild? before = client.guilds.cache.get(websocketResponse.payload['id']);

    GuildRoleManager roleManager = GuildRoleManager(websocketResponse.payload['id']);
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    MemberManager memberManager = MemberManager();
    memberManager.cache.addAll(before!.members.cache);

    ChannelManager channelManager = ChannelManager(before.id);
    channelManager.cache.addAll(before.channels.cache);

    EmojiManager emojiManager = EmojiManager();
    emojiManager.cache.addAll(before.emojis.cache);

    ModerationRuleManager moderationManager = ModerationRuleManager(websocketResponse.payload['id']);

    WebhookManager webhookManager = WebhookManager(before.id, null);
    webhookManager.cache.addAll(before.webhooks.cache);

    GuildScheduledEventManager guildScheduledEventManager = GuildScheduledEventManager();
    guildScheduledEventManager.cache.addAll(before.scheduledEvents.cache);

    Guild after = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
      moderationRuleManager: moderationManager,
      webhookManager: webhookManager,
      payload: websocketResponse.payload,
      guildScheduledEventManager: guildScheduledEventManager
    );

    after.stickers.guild = after;
    after.stickers.cache.forEach((_, sticker) {
      sticker.guild = after;
      sticker.member = after.channels.cache.get(sticker.member?.id);
    });

    after.afkChannel = after.channels.cache.get<VoiceChannel>(after.afkChannelId);
    after.systemChannel = after.channels.cache.get<TextChannel>(after.systemChannelId);
    after.rulesChannel = after.channels.cache.get<TextChannel>(after.rulesChannelId);
    after.publicUpdatesChannel = after.channels.cache.get<TextChannel>(after.publicUpdatesChannelId);
    after.emojis.guild = after;

    manager.emit(
      event: Events.guildUpdate,
      params: [before, after]
    );

    client.guilds.cache.set(after.id, after);
  }
}
