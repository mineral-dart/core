import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerRolesUpdateEventHandler = FutureOr<void> Function(Role, Role, Server);

abstract class ServerRolesUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverRoleUpdate;

  FutureOr<void> handle(Role before, Role after, Server server);
}
