import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

class MemberJoinRequest implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberJoinRequest;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['request']['guild_id']);

    if(payload['status'] == 'APPROVED' && guild != null) {
      GuildMember? member = guild.members.cache.get(payload['request']['user_id']);

      manager.emit(
        event: Events.acceptRules,
        params: [member]
      );
    }

  }
}
