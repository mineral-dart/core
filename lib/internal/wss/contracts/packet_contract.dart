import 'package:mineral/internal/wss/entities/websocket_response.dart';

abstract interface class PacketContract  {
  Future<void> handle (WebsocketResponse response);
}