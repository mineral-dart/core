import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMemberRemoveEventHandler = FutureOr<void> Function(User?, Server);

abstract class ServerMemberRemoveEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMemberRemove;

  @override
  Function get handler => handle;

  FutureOr<void> handle(User? user, Server server);
}
