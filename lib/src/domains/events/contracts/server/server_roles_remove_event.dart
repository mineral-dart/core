import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRolesDeleteEventHandler = FutureOr<void> Function(Server, Role?);

abstract class ServerRolesDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleDelete;

  @override
  String? customId;

  FutureOr<void> handle(Server server, Role? role);
}
