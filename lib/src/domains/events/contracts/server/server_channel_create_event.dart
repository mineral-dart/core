import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerChannelCreateEventHandler = FutureOr<void> Function(
    ServerChannel channel);

abstract class ServerChannelCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverChannelCreate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerChannel channel);
}
