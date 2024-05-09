import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef PrivateChannelPinsUpdateEventHandler = FutureOr<void> Function(PrivateChannel?);

abstract class PrivateChannelPinsUpdateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateChannelPinsUpdate;

  FutureOr<void> handle(PrivateChannel channel);
}
