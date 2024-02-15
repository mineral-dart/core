import 'dart:async';

import 'package:mineral/api/server/role.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerRolesCreateEventHandler = FutureOr<void> Function(Role);

abstract class ServerRolesCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverRoleCreate;

  FutureOr<void> handle(Role role);
}
