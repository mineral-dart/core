import 'dart:isolate';

import 'package:mineral/internal/factories/contracts/event_contract.dart';
import 'package:mineral/internal/factories/event_factory.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class EmbeddedDispatcher {
  final EventFactory _factory = EventFactory();
  late final WebsocketEventDispatcher _dispatcher;
  final SendPort? _devPort;

  EmbeddedDispatcher(this._devPort, List<EventContract Function()> events) {
    _factory.events.addAll(events);
    _dispatcher = WebsocketEventDispatcher(_factory);
  }

  Future<void> spawn () async {
    final ReceivePort port = ReceivePort();
    final Stream stream = port.asBroadcastStream();

    _devPort!.send(port.sendPort);
    await for (final Map<String, dynamic> message in stream) {
      final response = WebsocketResponse.fromWebsocket(message);
      _dispatcher.dispatch(response);
    }
  }
}