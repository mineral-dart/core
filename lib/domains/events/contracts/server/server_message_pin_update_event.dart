import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessagePinUpdateEventHandler = FutureOr<void> Function(Server server, ServerMessage message);

abstract class ServerMessagePinUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessagePinUpdate;

  FutureOr<void> handle(Server server, ServerMessage message);
}
