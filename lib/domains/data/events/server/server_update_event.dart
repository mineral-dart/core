import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerUpdateEventHandler = FutureOr<void> Function(Server, Server);

abstract class ServerUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverUpdate;

  FutureOr<void> handle(Server before, Server after);
}
