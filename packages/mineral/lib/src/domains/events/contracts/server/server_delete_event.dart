import 'dart:async';

import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerDeleteEventHandler = FutureOr<void> Function(Server?);

abstract class ServerDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverDelete;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server? server);
}
