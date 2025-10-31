import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRolesCreateEventHandler = FutureOr<void> Function(
  Server,
  Role,
);

abstract class ServerRolesCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleCreate;

  @override
  String? customId;

  FutureOr<void> handle(
    Server server,
    Role role,
  );
}
