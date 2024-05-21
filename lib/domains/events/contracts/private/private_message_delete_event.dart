import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateMessageDeleteEventHandler = FutureOr<void> Function(PrivateMessage?);

abstract class PrivateMessageDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageDelete;

  FutureOr<void> handle(PrivateMessage? message);
}
