import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateMessageReactionRemoveAllHandler = FutureOr<void> Function(
    PrivateChannel, Message);

abstract class PrivateMessageReactionRemoveAllEvent
    extends BaseListenableEvent {
  @override
  Event get event => Event.privateMessageReactionRemoveAll;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateChannel channel, Message message);
}
