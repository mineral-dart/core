import 'dart:collection';

import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class WebsocketEventDispatcher {
  final Queue<WebsocketResponse> _eventQueue = Queue();

  Future<void> dispatch (WebsocketResponse response, { bool pushToQueue = false }) async {
    print(response.type);
  }

  void restoreEvents () {
    while (_eventQueue.isNotEmpty) {
      dispatch(_eventQueue.removeFirst());
    }
  }
}