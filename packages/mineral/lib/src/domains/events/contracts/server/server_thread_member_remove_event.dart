import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadMemberRemoveEventHandler = FutureOr<void> Function(
    ThreadChannel, Server, Member);

abstract class ServerThreadMemberRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadMemberRemove;

  FutureOr<void> handle(ThreadChannel thread, Server server, Member member);
}
