import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMessageEventHandler = FutureOr<void> Function(ServerMessage);

abstract class ServerMessageCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMessageCreate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerMessage message);
}
