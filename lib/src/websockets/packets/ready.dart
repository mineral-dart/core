import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    MineralClient client = MineralClient.from(payload: websocketResponse.payload);

    ioc.bind(namespace: Service.client, service: client);
  }
}
