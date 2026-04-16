import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerThreadMemberUpdateEventHandler = FutureOr<void> Function(
    ThreadChannel, Server, Member);

abstract class ServerThreadMemberUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverThreadMemberUpdate;

  FutureOr<void> handle(ThreadChannel thread, Server server, Member member);
}
