import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMemberRemoveEventHandler = FutureOr<void> Function(User?, Server);

abstract class ServerMemberRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberRemove;

  @override
  String? customId;

  FutureOr<void> handle(User? user, Server server);
}
