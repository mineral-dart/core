import 'dart:async';

import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageDeleteEventHandler = FutureOr<void> Function(ServerMessage?);

abstract class ServerMessageDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageDelete;

  FutureOr<void> handle(ServerMessage? message);
}
