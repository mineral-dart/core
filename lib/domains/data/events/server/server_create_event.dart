import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerCreateEventHandler = FutureOr<void> Function(Server);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverCreate;

  FutureOr<void> handle(Server server);
}
