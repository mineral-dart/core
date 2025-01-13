import 'dart:async';

import 'package:mineral/src/api/server/message_reaction.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateMessageReactionAddHandler = FutureOr<void> Function(MessageReaction reaction);

abstract class PrivateMessageReactionAddEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionAdd;

  @override
  String? customId;

  FutureOr<void> handle(MessageReaction reaction);
}
