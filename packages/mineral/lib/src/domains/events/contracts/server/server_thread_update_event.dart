import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadUpdateEventHandler = FutureOr<void> Function(
    Server, ThreadChannel?, ThreadChannel);

abstract class ServerThreadUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadUpdate;

  FutureOr<void> handle(Server server, ThreadChannel before, ThreadChannel after);
}
