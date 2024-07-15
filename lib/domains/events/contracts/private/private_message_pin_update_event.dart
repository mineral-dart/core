import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateMessagePinUpdateEventHandler = FutureOr<void> Function(PrivateChannel?);

abstract class PrivateMessagePinUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessagePinUpdate;

  FutureOr<void> handle(PrivateChannel channel);
}
