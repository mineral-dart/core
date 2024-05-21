import 'dart:async';

import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMemberUpdateEventHandler = FutureOr<void> Function(Member, Member, Server);

abstract class ServerMemberUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberUpdate;

  FutureOr<void> handle(Member after, Member before, Server server);
}
