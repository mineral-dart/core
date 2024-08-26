import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerThreadListSyncEventHandler = FutureOr<void> Function(List<ThreadChannel>, Server);

abstract class ServerThreadListSyncEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadListSync;

  FutureOr<void> handle(List<ThreadChannel> threads, Server server);
}
