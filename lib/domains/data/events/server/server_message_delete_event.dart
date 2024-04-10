import 'dart:async';

import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerMessageDeleteEventHandler = FutureOr<void> Function(ServerMessage?);

abstract class ServerMessageDeleteEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMessageDelete;

  FutureOr<void> handle(ServerMessage? message);
}
