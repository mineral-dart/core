import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRolesDeleteEventHandler = FutureOr<void> Function(Server, Role?);

abstract class ServerRolesDeleteEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRoleDelete;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, Role? role);
}
