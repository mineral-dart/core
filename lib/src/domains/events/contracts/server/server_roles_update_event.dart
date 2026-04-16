import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRolesUpdateEventHandler = FutureOr<void> Function(
    Server, Role, Role);

abstract class ServerRolesUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRoleUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, Role before, Role after);
}
