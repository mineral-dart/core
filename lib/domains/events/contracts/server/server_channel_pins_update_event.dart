import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerChannelPinsUpdateEventHandler = FutureOr<void> Function(Server, ServerChannel?);

abstract class ServerChannelPinsUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelPinsUpdate;

  FutureOr<void> handle(Server server, ServerChannel channel);
}