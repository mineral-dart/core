import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerBanAddEventHandler = FutureOr<void> Function(Member?, User, Server);

abstract class ServerBanAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverBanAdd;

  FutureOr<void> handle(Member? member, User user, Server server);
}
