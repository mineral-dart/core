import 'package:http/http.dart';
import 'package:mineral/api.dart';
import "dart:convert";
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class GuildCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    Http http = ioc.singleton(Service.http);
    
    RoleManager roleManager = RoleManager(guildId: websocketResponse.payload['id']);
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(item);
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
    for (dynamic payload in websocketResponse.payload['channels']) {
      if (channels.containsKey(payload['type'])) {
        Channel Function(dynamic payload) item = channels[payload['type']] as Channel Function(dynamic payload);
        Channel channel = item(payload);

        channelManager.cache.putIfAbsent(channel.id, () => channel);
      }
    }

    EmojiManager emojiManager = EmojiManager(guildId: websocketResponse.payload['id']);
    for (dynamic payload in websocketResponse.payload['emojis']) {
      Emoji emoji = Emoji.from(
        memberManager: memberManager,
        roleManager: roleManager,
        payload: payload
      );

      emojiManager.cache.putIfAbsent(emoji.id, () => emoji);
    }

    Guild guild = Guild.from(
      emojiManager: emojiManager,
      memberManager: memberManager,
      roleManager: roleManager,
      channelManager: channelManager,
      payload: websocketResponse.payload
    );

    // Assign guild members
    guild.members.cache.forEach((Snowflake id, GuildMember member) {
      member.guild = guild;
    });

    // Assign guild channels
    channelManager.guild = guild;
    
    guild.channels.cache.forEach((Snowflake id, Channel channel) async {
      channel.guildId = guild.id;
      channel.guild = guild;
      channel.parent = channel.parentId != null 
        ? guild.channels.cache.get<CategoryChannel>(channel.parentId) 
        : null;

      Response response = await http.get("/channels/${channel.id}/messages");
      dynamic payload = jsonDecode(response.body);
      for (dynamic element in payload) {
        Message message = Message.from(channel: channel as TextBasedChannel, payload: element);
        channel.messages.cache.set(message.id, message);
      }
    });
    Response response = await http.get('/channels/977261752976830474/messages/977339647908773969');
    dynamic payload = jsonDecode(response.body);
    print(payload);
  }
}
