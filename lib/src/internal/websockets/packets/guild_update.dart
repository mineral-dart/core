import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/channel.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/moderation_rule_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
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
    for (dynamic member in websocketResponse.payload['members']) {
      GuildMember guildMember = GuildMember.from(
        roles: roleManager,
        user: User.from(member['user']),
        member: member,
        guildId: websocketResponse.payload['id']
      );

      memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
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
        roleManager: roleManager,
        emojiManager: emojiManager,
        payload: payload
      );

      emojiManager.cache.putIfAbsent(emoji.id, () => emoji);
    }

    ModerationRuleManager moderationManager = ModerationRuleManager(guildId: websocketResponse.payload['id']);

    Guild after = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
        moderationRuleManager: moderationManager,
      payload: websocketResponse.payload
    );

    // Assign guild members
    after.members.cache.forEach((Snowflake id, GuildMember member) {
      member.guild = after;
      member.voice.member = member;
      member.voice.channel = after.channels.cache.get(member.voice.channelId);
    });

    // Assign guild channels
    channelManager.guild = after;
    after.channels.cache.forEach((Snowflake id, Channel channel) {
      channel.guildId = after.id;
      channel.guild = after;
      channel.parent = channel.parentId != null ? after.channels.cache.get<CategoryChannel>(channel.parentId) : null;
    });

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

    manager.emit(Events.guildUpdate, [before, after]);
    client.guilds.cache.set(after.id, after);
  }
}
