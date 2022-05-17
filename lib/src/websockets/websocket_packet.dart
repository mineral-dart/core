import 'package:mineral/src/constants.dart';
import 'package:mineral/src/websockets/websocket_response.dart';

abstract class WebsocketPacket {
  abstract PacketType packetType;
  Future<void> handle (WebsocketResponse websocketResponse);
}
