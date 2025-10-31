import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadMemberAddEventHandler = FutureOr<void> Function(
  ThreadChannel,
  Server,
  Member,
);

abstract class ServerThreadMemberAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadMemberAdd;

  FutureOr<void> handle(
    ThreadChannel thread,
    Server server,
    Member member,
  );
}
