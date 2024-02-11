import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerChannelUpdateEventHandler = FutureOr<void> Function(ServerChannel, ServerChannel);

abstract class ServerChannelUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverChannelUpdate;

  FutureOr<void> handle(ServerChannel before, ServerChannel after);
}
