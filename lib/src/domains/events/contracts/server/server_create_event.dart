import 'dart:async';

import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerCreateEventHandler = FutureOr<void> Function(Server);

abstract class ServerCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverCreate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server);
}
