import 'dart:async';

import 'package:mineral/src/api/common/message_reaction.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateMessageReactionRemoveHandler = FutureOr<void> Function(MessageReaction reaction);

abstract class PrivateMessageReactionRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionRemove;

  @override
  String? customId;

  FutureOr<void> handle(MessageReaction reaction);
}
