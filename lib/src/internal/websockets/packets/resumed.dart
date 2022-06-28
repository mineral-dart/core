import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class Resumed implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.resumed;

  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    print(websocketResponse.payload);
  }
}
