import 'dart:async';

import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMemberAddEventHandler = FutureOr<void> Function(Member, Server);

abstract class ServerMemberAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberAdd;

  FutureOr<void> handle(Member member, Server server);
}
