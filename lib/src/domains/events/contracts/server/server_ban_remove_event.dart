import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerBanRemoveEventHandler = FutureOr<void> Function(User, Server);

abstract class ServerBanRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverBanRemove;

  @override
  String? customId;

  FutureOr<void> handle(User user, Server server);
}
