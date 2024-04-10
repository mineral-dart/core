import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageDeleteBulkEventHandler = FutureOr<void> Function(List<PrivateMessage>);

abstract class PrivateMessageDeleteBulkEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageDeleteBulk;

  FutureOr<void> handle(List<PrivateMessage> messages);
}
