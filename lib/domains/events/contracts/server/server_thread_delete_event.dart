import 'dart:async';

import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerThreadDeleteEventHandler = FutureOr<void> Function(ThreadChannel, Server);

abstract class ServerThreadDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadDelete;

  FutureOr<void> handle(ThreadChannel thread, Server server);
}
