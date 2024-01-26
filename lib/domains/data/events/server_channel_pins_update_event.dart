import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerChannelPinsUpdateEventHandler = FutureOr<void> Function(Server, ServerChannel, DateTime?);

abstract class ServerChannelPinsUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverChannelPinsUpdate;

  FutureOr<void> handle(Server server, ServerChannel channel, DateTime? lastPin);
}
