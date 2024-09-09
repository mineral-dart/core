import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerBanAddEventHandler = FutureOr<void> Function(
    Member?, User, Server);

abstract class ServerBanAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverBanAdd;

  @override
  String? customId;

  FutureOr<void> handle(Member? member, User user, Server server);
}
