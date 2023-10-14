import 'dart:isolate';

import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class EmbeddedDispatcher {
  final SendPort? _devPort;
  final List _events;

  EmbeddedDispatcher(this._devPort, this._events);

  Future<void> spawn () async {
    final ReceivePort port = ReceivePort();
    final Stream stream = port.asBroadcastStream();

    _devPort!.send(port.sendPort);
    await for (final message in stream) {
      final x = WebsocketResponse.fromWebsocket(message);
      print(x);

      final event = _events.first();
      event.handle('c');
    }
  }
}