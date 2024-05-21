import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateMessageDeleteBulkEventHandler = FutureOr<void> Function(List<PrivateMessage>);

abstract class PrivateMessageDeleteBulkEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageDeleteBulk;

  FutureOr<void> handle(List<PrivateMessage> messages);
}
