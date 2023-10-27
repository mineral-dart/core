import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:mineral/internal/factories/events/contracts/event_contract.dart';
import 'package:mineral/internal/factories/events/event_factory.dart';
import 'package:mineral/internal/factories/packages/contracts/package_contract.dart';
import 'package:mineral/internal/factories/packages/package_factory.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';

final class EmbeddedDispatcher {
  final Logger _logger;

  final EventFactory _eventFactory = container.bind('Mineral/Factories/Event', (_) => EventFactory());
  late final PackageFactory _packageFactory;

  late final WebsocketEventDispatcher _dispatcher;
  final SendPort? _devPort;

  EmbeddedDispatcher(this._devPort, this._logger, List<EventContract Function()> events, List<PackageContract Function()> packages) {
    _eventFactory.registerMany(events);
    _dispatcher = WebsocketEventDispatcher(_eventFactory);

    _packageFactory = PackageFactory(_logger);
    _packageFactory.registerMany(packages);
    _packageFactory.init();
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