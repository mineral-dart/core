import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerBanAddEventHandler = FutureOr<void> Function(Member?, User, Server);

abstract class ServerBanAddEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverBanAdd;

  FutureOr<void> handle(Member? member, User user, Server server);
}
