import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMemberRemoveEventHandler = FutureOr<void> Function(Member?, User, Server);

abstract class ServerMemberRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberRemove;

  FutureOr<void> handle(Member? member, User user, Server server);
}
