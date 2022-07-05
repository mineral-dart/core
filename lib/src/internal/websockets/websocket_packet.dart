import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral/core.dart';

abstract class WebsocketPacket {
  abstract PacketType packetType;
  Future<void> handle (WebsocketResponse websocketResponse);
}
