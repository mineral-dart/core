import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateChannelCreateEventHandler = FutureOr<void> Function(PrivateChannel channel);

abstract class PrivateChannelCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateChannelCreate;

  FutureOr<void> handle(ServerChannel channel);
}
