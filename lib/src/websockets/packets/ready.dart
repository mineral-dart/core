import 'package:mineral/src/constants.dart';
import 'package:mineral/src/websockets/websocket_packet.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

class Ready implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    print('Ready');
  }
}
