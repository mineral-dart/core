import 'package:mineral/src/internal/websockets/websocket_response.dart';

abstract class WebsocketPacket {
  Future<void> handle (WebsocketResponse websocketResponse);
}
