import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMemberUpdateEventHandler = FutureOr<void> Function(
    Server, Member?, Member);

abstract class ServerMemberUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMemberUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, Member after, Member before);
}
