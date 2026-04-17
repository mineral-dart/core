import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerThreadMemberAddEventHandler = FutureOr<void> Function(
    ThreadChannel, Server, Member);

abstract class ServerThreadMemberAddEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverThreadMemberAdd;

  FutureOr<void> handle(ThreadChannel thread, Server server, Member member);
}
