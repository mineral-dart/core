import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    Guild? before = client.guilds.cache.get(websocketResponse.payload['id']);

    RoleManager roleManager = RoleManager(guildId: websocketResponse.payload['id']);
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(roleManager: roleManager, payload: item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    MemberManager memberManager = MemberManager(guildId: websocketResponse.payload['id']);
    memberManager.cache.addAll(before!.members.cache);

    ChannelManager channelManager = ChannelManager(guildId: websocketResponse.payload['id']);
    channelManager.cache.addAll(before.channels.cache);

    EmojiManager emojiManager = EmojiManager(guildId: websocketResponse.payload['id']);
    emojiManager.cache.addAll(before.emojis.cache);

    ModerationRuleManager moderationManager = ModerationRuleManager(guildId: websocketResponse.payload['id']);

    WebhookManager webhookManager = WebhookManager(guildId: websocketResponse.payload['id']);
    webhookManager.cache.addAll(before.webhooks.cache);

    Guild after = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
      moderationRuleManager: moderationManager,
      webhookManager: webhookManager,
      payload: websocketResponse.payload
    );

    moderationManager.guild = after;

    after.stickers.guild = after;
    after.stickers.cache.forEach((_, sticker) {
      sticker.guild = after;
      sticker.guildMember = after.channels.cache.get(sticker.guildMemberId);
    });

    after.afkChannel = after.channels.cache.get<VoiceChannel>(after.afkChannelId);
    after.systemChannel = after.channels.cache.get<TextChannel>(after.systemChannelId);
    after.rulesChannel = after.channels.cache.get<TextChannel>(after.rulesChannelId);
    after.publicUpdatesChannel = after.channels.cache.get<TextChannel>(after.publicUpdatesChannelId);
    after.emojis.guild = after;
    after.roles.guild = after;

    manager.emit(
      event: Events.guildUpdate,
      params: [before, after]
    );

    client.guilds.cache.set(after.id, after);
  }
}
