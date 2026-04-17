import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerThreadDeleteEventHandler = FutureOr<void> Function(
    ThreadChannel, Server);

abstract class ServerThreadDeleteEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverThreadDelete;

  FutureOr<void> handle(ThreadChannel thread, Server server);
}
