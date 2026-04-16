import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMessageReactionRemoveAllHandler = FutureOr<void> Function(
    Server, ServerTextChannel, Message);

abstract class ServerMessageReactionRemoveAllEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemoveAll;

  @override
  Function get handler => handle;

  FutureOr<void> handle(
      Server server, ServerTextChannel channel, Message message);
}
