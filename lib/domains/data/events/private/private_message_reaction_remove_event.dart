import 'dart:async';

import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageReactionRemoveEventHandler = FutureOr<void> Function(PrivateMessage, ReactionEmoji<PrivateChannel>, PrivateChannel, User);

abstract class PrivateMessageReactionRemoveEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageReactionRemove;

  FutureOr<void> handle(PrivateMessage message, ReactionEmoji<PrivateChannel> reaction, PrivateChannel channel, User user);
}
