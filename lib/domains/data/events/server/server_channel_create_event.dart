import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ServerChannelCreateEventHandler = FutureOr<void> Function(ServerChannel channel);

abstract class ServerChannelCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverChannelCreate;

  FutureOr<void> handle(ServerChannel channel);
}
