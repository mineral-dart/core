import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerBanRemoveEventHandler = FutureOr<void> Function(User, Server);

abstract class ServerBanRemoveEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverBanRemove;

  FutureOr<void> handle(User user, Server server);
}
