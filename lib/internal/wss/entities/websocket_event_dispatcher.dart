import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class WebsocketEventDispatcher {
  WebsocketEventDispatcher();

  Future<void> dispatch (WebsocketResponse response) async {
    print(response.type);
  }
}