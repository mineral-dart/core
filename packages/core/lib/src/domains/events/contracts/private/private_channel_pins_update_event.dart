import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateChannelPinsUpdateEventHandler = FutureOr<void> Function(
    PrivateChannel?);

abstract class PrivateChannelPinsUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateChannelPinsUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateChannel channel);
}
