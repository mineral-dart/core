import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';

typedef ServerCreateEventHandler = FutureOr<void> Function(Server server);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  String get event => 'ServerCreateEvent';

  FutureOr<void> handle(Server server);
}
