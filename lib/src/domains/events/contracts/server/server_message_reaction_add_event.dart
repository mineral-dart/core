import 'dart:async';

import 'package:mineral/src/api/common/message_reaction.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerMessageReactionAddHandler = FutureOr<void> Function(
  MessageReaction reaction,
);

abstract class ServerMessageReactionAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMessageReactionAdd;

  @override
  String? customId;

  FutureOr<void> handle(
    MessageReaction reaction,
  );
}
