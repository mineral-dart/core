import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerChannelDeleteEventHandler = FutureOr<void> Function(
    ServerChannel?);

abstract class ServerChannelDeleteEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverChannelDelete;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerChannel? channel);
}
