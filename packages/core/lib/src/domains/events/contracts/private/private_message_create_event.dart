import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateMessageCreateEventHandler = FutureOr<void> Function(
    PrivateMessage);

abstract class PrivateMessageCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateMessageCreate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateMessage message);
}
