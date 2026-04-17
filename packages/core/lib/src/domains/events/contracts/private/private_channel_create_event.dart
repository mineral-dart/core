import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateChannelCreateEventHandler = FutureOr<void> Function(
    PrivateChannel);

abstract class PrivateChannelCreateEvent extends BaseListenableEvent {
  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateChannel channel);
}
