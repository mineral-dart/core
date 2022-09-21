import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildMemberRemove implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberRemove;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['user']['id']);

    if(guild != null && member != null) {
      manager.emit(
        event: Events.memberLeave,
        params: [member]
      );

      guild.members.cache.remove(member.user.id);
    }
  }
}
