import 'dart:async';

import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMessageReactionRemoveAllEventHandler = FutureOr<void> Function(ServerMessage, Server);

abstract class ServerMessageReactionAllRemoveEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMessageReactionRemoveAll;

  FutureOr<void> handle(ServerMessage message, Server server);
}
