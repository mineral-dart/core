import 'dart:async';

import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadUpdateEventHandler = FutureOr<void> Function(
    ThreadChannel, ThreadChannel, Server);

abstract class ServerThreadUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadUpdate;

  FutureOr<void> handle(
      ThreadChannel before, ThreadChannel after, Server server);
}
