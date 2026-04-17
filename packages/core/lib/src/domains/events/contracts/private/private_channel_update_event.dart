import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateChannelUpdateEventHandler = FutureOr<void> Function(
    PrivateChannel?, PrivateChannel);

abstract class PrivateChannelUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateChannelUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateChannel? before, PrivateChannel after);
}
