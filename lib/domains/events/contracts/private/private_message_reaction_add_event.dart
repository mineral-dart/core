import 'dart:async';

import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/domains/events/event.dart';

typedef PrivateMessageReactionAddEventHandler = FutureOr<void> Function(PrivateMessage, ReactionEmoji<PrivateChannel>, PrivateChannel, User);

abstract class PrivateMessageReactionAddEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionAdd;

  FutureOr<void> handle(PrivateMessage message, ReactionEmoji<PrivateChannel> reaction, PrivateChannel channel, User user);
}
