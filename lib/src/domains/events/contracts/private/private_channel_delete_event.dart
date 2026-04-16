import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateChannelDeleteEventHandler = FutureOr<void> Function(
    PrivateChannel);

abstract class PrivateChannelDeleteEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateChannelDelete;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateChannel channel);
}
