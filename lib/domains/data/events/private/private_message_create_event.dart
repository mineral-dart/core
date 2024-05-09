import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef PrivateMessageEventHandler = FutureOr<void> Function(PrivateMessage);

abstract class PrivateMessageEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageCreate;

  FutureOr<void> handle(PrivateMessage message);
}
