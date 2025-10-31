import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMemberAddEventHandler = FutureOr<void> Function(Member, Server);

abstract class ServerMemberAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberAdd;

  @override
  String? customId;

  FutureOr<void> handle(
    Member member,
    Server server,
  );
}
