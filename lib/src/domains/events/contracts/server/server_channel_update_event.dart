import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerChannelUpdateEventHandler = FutureOr<void> Function(
    ServerChannel, ServerChannel);

abstract class ServerChannelUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverChannelUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerChannel before, ServerChannel after);
}
