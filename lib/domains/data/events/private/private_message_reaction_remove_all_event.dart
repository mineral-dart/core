import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageReactionRemoveAllEventHandler = FutureOr<void> Function(PrivateMessage, PrivateChannel);

abstract class PrivateMessageReactionRemoveAllEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageReactionRemoveAll;

  FutureOr<void> handle(PrivateMessage message, PrivateChannel channel);
}
