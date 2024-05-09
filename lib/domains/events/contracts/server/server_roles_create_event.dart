import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerRolesCreateEventHandler = FutureOr<void> Function(Role, Server);

abstract class ServerRolesCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverRoleCreate;

  FutureOr<void> handle(Role role, Server server);
}
