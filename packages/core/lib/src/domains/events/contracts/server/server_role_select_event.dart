import 'dart:async';

import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRoleSelectEventHandler = FutureOr Function(
    ServerSelectContext, List<Role>);

abstract class ServerRoleSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRoleSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<Role> roles);
}
