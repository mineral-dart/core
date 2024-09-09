import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRolesCreateEventHandler = FutureOr<void> Function(Role, Server);

abstract class ServerRolesCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleCreate;

  @override
  String? customId;

  FutureOr<void> handle(Role role, Server server);
}
