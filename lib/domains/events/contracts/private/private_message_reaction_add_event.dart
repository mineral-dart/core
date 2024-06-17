import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/private_reaction.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateMessageReactionAddEventHandler = FutureOr<void> Function(User, PrivateReaction, PrivateMessage, PrivateChannel);

abstract class PrivateMessageReactionAddEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionAdd;

  FutureOr<void> handle(User user, PrivateReaction reaction, PrivateMessage message, PrivateChannel channel);
}
