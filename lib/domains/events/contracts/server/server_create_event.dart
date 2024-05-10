import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerCreateEventHandler = FutureOr<void> Function(Server);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverCreate;

  FutureOr<void> handle(Server server);
}
