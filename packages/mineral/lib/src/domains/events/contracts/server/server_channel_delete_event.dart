import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerChannelDeleteEventHandler = FutureOr<void> Function(
    ServerChannel?);

abstract class ServerChannelDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelDelete;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerChannel? channel);
}
