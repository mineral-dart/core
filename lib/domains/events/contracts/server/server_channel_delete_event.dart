import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ServerChannelDeleteEventHandler = FutureOr<void> Function(ServerChannel?);

abstract class ServerChannelDeleteEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.serverChannelDelete;

  FutureOr<void> handle(ServerChannel? channel);
}
