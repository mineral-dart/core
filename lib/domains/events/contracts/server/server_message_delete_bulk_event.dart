import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMessageDeleteBulkEventHandler = FutureOr<void> Function(List<ServerMessage>, Server);

abstract class ServerMessageDeleteBulkEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageDeleteBulk;

  FutureOr<void> handle(List<ServerMessage> messages, Server server);
}
