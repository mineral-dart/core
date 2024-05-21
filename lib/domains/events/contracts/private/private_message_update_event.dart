import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateMessageUpdateEventHandler = FutureOr<void> Function(PrivateMessage?, PrivateMessage);

abstract class PrivateMessageUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageUpdate;

  FutureOr<void> handle(PrivateMessage? oldMessage, PrivateMessage message);
}
