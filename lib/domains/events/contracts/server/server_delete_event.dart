import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerDeleteEventHandler = FutureOr<void> Function(Server?);

abstract class ServerDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverDelete;

  @override
  String? customId;

  FutureOr<void> handle(Server? server);
}
