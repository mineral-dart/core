import 'dart:async';

import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerMessageEventHandler = FutureOr<void> Function(ServerMessage);

abstract class ServerMessageCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverMessageCreate;

  FutureOr<void> handle(ServerMessage message);
}
