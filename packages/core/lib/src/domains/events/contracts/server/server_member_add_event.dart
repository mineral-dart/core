import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMemberAddEventHandler = FutureOr<void> Function(Member, Server);

abstract class ServerMemberAddEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMemberAdd;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Member member, Server server);
}
