import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerRolesDeleteEventHandler = FutureOr<void> Function(Role?, Server);

abstract class ServerRolesDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleDelete;

  FutureOr<void> handle(Role? role, Server server);
}