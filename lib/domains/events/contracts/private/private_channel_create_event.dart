import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef PrivateChannelCreateEventHandler = FutureOr<void> Function(PrivateChannel);

abstract class PrivateChannelCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateChannelCreate;

  FutureOr<void> handle(ServerChannel channel);
}
