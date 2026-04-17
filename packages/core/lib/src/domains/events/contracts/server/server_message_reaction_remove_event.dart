import 'dart:async';

import 'package:mineral/src/api/common/message_reaction.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMessageReactionRemoveHandler = FutureOr<void> Function(
    MessageReaction reaction);

abstract class ServerMessageReactionRemoveEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemove;

  @override
  Function get handler => handle;

  FutureOr<void> handle(MessageReaction reaction);
}
