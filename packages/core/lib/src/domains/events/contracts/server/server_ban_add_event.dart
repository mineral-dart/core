import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerBanAddEventHandler = FutureOr<void> Function(
    Member?, User, Server);

abstract class ServerBanAddEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverBanAdd;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Member? member, User user, Server server);
}
