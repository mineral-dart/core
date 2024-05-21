import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/domains/events/event.dart';

typedef PrivateMessageReactionRemoveAllEventHandler = FutureOr<void> Function(PrivateMessage, PrivateChannel);

abstract class PrivateMessageReactionRemoveAllEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageReactionRemoveAll;

  FutureOr<void> handle(PrivateMessage message, PrivateChannel channel);
}
