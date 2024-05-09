import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerRolesDeleteEventHandler = FutureOr<void> Function(Role?, Server);

abstract class ServerRolesDeleteEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverRoleDelete;

  FutureOr<void> handle(Role? role, Server server);
}
