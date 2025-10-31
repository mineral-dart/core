import 'dart:async';

import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMemberUpdateEventHandler = FutureOr<void> Function(
  Server,
  Member?,
  Member,
);

abstract class ServerMemberUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberUpdate;

  @override
  String? customId;

  FutureOr<void> handle(
    Server server,
    Member after,
    Member before,
  );
}
