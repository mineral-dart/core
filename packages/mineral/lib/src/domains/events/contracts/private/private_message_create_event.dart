import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateMessageCreateEventHandler = FutureOr<void> Function(
    PrivateMessage);

abstract class PrivateMessageCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMessageCreate;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateMessage message);
}
