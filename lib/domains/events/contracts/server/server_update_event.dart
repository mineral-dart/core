import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerUpdateEventHandler = FutureOr<void> Function(Server, Server);

abstract class ServerUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverUpdate;

  @override
  String? customId;

  FutureOr<void> handle(Server before, Server after);
}
