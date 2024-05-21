import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionRemoveAllEventHandler = FutureOr<void> Function(ServerMessage, Server);

abstract class ServerMessageReactionRemoveAllEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemoveAll;

  FutureOr<void> handle(ServerMessage message, Server server);
}
