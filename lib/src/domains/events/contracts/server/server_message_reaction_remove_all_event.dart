import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionRemoveAllHandler = FutureOr<void> Function(Server, ServerTextChannel, Message);

abstract class ServerMessageReactionRemoveAllEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemoveAll;

  @override
  String? customId;

  FutureOr<void> handle(Server server, ServerTextChannel channel, Message message);
}
