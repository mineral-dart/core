import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerDeleteEventHandler = FutureOr<void> Function(Server);

abstract class ServerDeleteEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverDelete;

  FutureOr<void> handle(Server server);
}
