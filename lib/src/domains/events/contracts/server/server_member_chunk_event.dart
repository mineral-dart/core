import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMemberChunkEventHandler = FutureOr<void> Function(
    Server server, Map<Snowflake, Member> members);

abstract class ServerMemberChunkEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMemberChunk;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, Map<Snowflake, Member> members);
}
