import 'dart:async';

import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerThreadMemberUpdateEventHandler = FutureOr<void> Function(
    ThreadChannel, Server, Member);

abstract class ServerThreadMemberUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverThreadMemberUpdate;

  FutureOr<void> handle(ThreadChannel thread, Server server, Member member);
}
