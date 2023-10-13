import 'package:mineral/internal/wss/entities/websocket_response.dart';

abstract interface class EmbeddedApplication {
  void dispatch(WebsocketResponse response);
}