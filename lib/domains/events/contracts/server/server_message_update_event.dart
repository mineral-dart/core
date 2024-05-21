import 'dart:async';

import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageUpdateEventHandler = FutureOr<void> Function(ServerMessage?, ServerMessage);

abstract class ServerMessageUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageUpdate;

  FutureOr<void> handle(ServerMessage? oldMessage, ServerMessage message);
}
