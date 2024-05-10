import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerRolesUpdateEventHandler = FutureOr<void> Function(Role, Role, Server);

abstract class ServerRolesUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleUpdate;

  FutureOr<void> handle(Role before, Role after, Server server);
}
