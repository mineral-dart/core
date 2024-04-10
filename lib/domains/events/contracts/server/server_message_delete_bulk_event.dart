import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMessageDeleteBulkEventHandler = FutureOr<void> Function(List<ServerMessage>, Server);

abstract class ServerMessageDeleteBulkEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMessageDeleteBulk;

  FutureOr<void> handle(List<ServerMessage> messages, Server server);
}
