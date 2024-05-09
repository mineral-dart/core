import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerMemberRemoveEventHandler = FutureOr<void> Function(User, Server);

abstract class ServerMemberRemoveEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMemberRemove;

  FutureOr<void> handle(User user, Server server);
}
