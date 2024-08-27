import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerChannelUpdateEventHandler = FutureOr<void> Function(
    ServerChannel, ServerChannel);

abstract class ServerChannelUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelUpdate;

  @override
  String? customId;

  FutureOr<void> handle(ServerChannel before, ServerChannel after);
}
