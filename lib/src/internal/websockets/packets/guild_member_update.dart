import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildMemberUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      GuildMember? before = guild.members.cache.get(payload['user']['id']);

      User user = User.from(payload['user']);
      GuildMember after = GuildMember.from(user: user, roles: guild.roles, guildId: guild.id, member: payload);

      after.guild = guild;
      after.voice.member = after;
      after.voice.channel = guild.channels.cache.get(after.voice.channelId);

      manager.emit(EventList.memberUpdate, [before, after]);

      if (before?.isPending != after.isPending) {
        manager.emit(EventList.acceptRules, [after]);
      }

      if (before?.roles.cache.length != after.roles.cache.length) {
        manager.emit(EventList.memberRolesUpdate, [before, after]);
      }

      guild.members.cache.set(after.user.id, after);
    }
  }
}
