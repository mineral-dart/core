import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageDeleteEventHandler = FutureOr<void> Function(PrivateMessage?);

abstract class PrivateMessageDeleteEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageDelete;

  FutureOr<void> handle(PrivateMessage? message);
}
