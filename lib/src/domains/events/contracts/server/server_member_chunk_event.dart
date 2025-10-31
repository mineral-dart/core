import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMemberChunkEventHandler = FutureOr<void> Function(
  Server server,
  Map<Snowflake, Member> members,
);

abstract class ServerMemberChunkEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberChunk;

  @override
  String? customId;

  FutureOr<void> handle(
    Server server,
    Map<Snowflake, Member> members,
  );
}
