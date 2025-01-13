import 'dart:async';

import 'package:mineral/src/api/common/message_reaction.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionRemoveHandler = FutureOr<void> Function(MessageReaction reaction);

abstract class ServerMessageReactionRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionRemove;

  @override
  String? customId;

  FutureOr<void> handle(MessageReaction reaction);
}
