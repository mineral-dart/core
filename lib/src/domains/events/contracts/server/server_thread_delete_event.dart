import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadDeleteEventHandler = FutureOr<void> Function(
  ThreadChannel,
  Server,
);

abstract class ServerThreadDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadDelete;

  FutureOr<void> handle(
    ThreadChannel thread,
    Server server,
  );
}
