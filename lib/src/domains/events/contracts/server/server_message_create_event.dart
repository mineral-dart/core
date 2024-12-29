import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMessageEventHandler = FutureOr<void> Function(ServerMessage);

abstract class ServerMessageCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageCreate;

  @override
  String? customId;

  FutureOr<void> handle(ServerMessage message);
}
