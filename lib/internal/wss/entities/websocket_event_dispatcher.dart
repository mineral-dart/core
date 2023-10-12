import 'dart:collection';

import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class WebsocketEventDispatcher {
  final Queue<WebsocketResponse> _eventQueue = Queue();
  bool _isRestoring = false;

  Future<void> dispatch (WebsocketResponse response, { bool pushToQueue = false }) async {
    if (pushToQueue) {
      _eventQueue.addLast(response);
    }

    // print(_eventQueue.length);
    // print(response.type);
  }

  void restoreEvents () {
    final queue = Queue<WebsocketResponse>.from(_eventQueue);

    _isRestoring = true;
    while (queue.isNotEmpty) {
      dispatch(queue.removeFirst());
    }
    _isRestoring = false;
  }
}