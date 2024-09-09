import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRoleSelectEventHandler = FutureOr Function(
    ServerSelectContext, List<Role>);

abstract class ServerRoleSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRoleSelect;

  @override
  String? customId;

  FutureOr<void> handle(ServerSelectContext ctx, List<Role> roles);
}
