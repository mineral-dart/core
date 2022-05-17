import 'package:mineral/src/api/guild.dart';
import 'package:mineral/src/api/guild_member.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/api/role.dart';
import 'package:mineral/src/api/user.dart';
import 'package:mineral/api.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class GuildCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.guildCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    RoleManager roleManager = RoleManager();
    for (dynamic item in websocketResponse.payload['roles']) {
      Role role = Role.from(item);
      roleManager.cache.putIfAbsent(role.id, () => role);
    }

    MemberManager memberManager = MemberManager();
    for(dynamic member in websocketResponse.payload['members']) {
      GuildMember guildMember = GuildMember.from(
        roles: roleManager,
        user: User.from(member['user']),
        member: member
      );

      memberManager.cache.putIfAbsent(guildMember.user.id, () => guildMember);
    }

    ChannelManager channelManager = ChannelManager();
    for(dynamic payload in websocketResponse.payload['channels']) {
      if (channels.containsKey(payload['type'])) {
        Channel Function(dynamic payload) item = channels[payload['type']] as Channel Function(dynamic payload);
        Channel channel = item(payload);

        channelManager.cache.putIfAbsent(channel.id, () => channel);
      }
    }

    Guild guild = Guild.from(
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
    guild.channels.cache.forEach((Snowflake id, Channel channel) {
      channel.guildId = guild.id;
      channel.guild = guild;
      channel.parent = channel.parentId != null? guild.channels.cache.get<CategoryChannel>(channel.parentId) : null;
    });
  }
}
