import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerChannelPinsUpdateEventHandler = FutureOr<void> Function(
    Server, ServerChannel?);

abstract class ServerChannelPinsUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverChannelPinsUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, ServerChannel channel);
}
