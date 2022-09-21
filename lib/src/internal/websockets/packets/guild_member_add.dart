import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildMemberAdd implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberAdd;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    if(guild != null) {
      User user = User.from(payload['user']);
      GuildMember member = GuildMember.from(
        user: user,
        roles: guild.roles,
        member: payload,
        guild: guild,
        voice: VoiceManager.empty(payload['deaf'], payload['mute'], user.id, guild.id)
      );

      guild.members.cache.putIfAbsent(member.user.id, () => member);
      manager.emit(event: Events.memberJoin, params: [member]);
    }
  }
}
