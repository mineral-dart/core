import 'dart:async';

import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerUpdateEventHandler = FutureOr<void> Function(Server, Server);

abstract class ServerUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server before, Server after);
}
