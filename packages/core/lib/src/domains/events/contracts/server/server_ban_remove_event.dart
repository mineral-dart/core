import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerBanRemoveEventHandler = FutureOr<void> Function(User, Server);

abstract class ServerBanRemoveEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverBanRemove;

  @override
  Function get handler => handle;

  FutureOr<void> handle(User user, Server server);
}
