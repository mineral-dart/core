import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateChannelPinsUpdateEventHandler = FutureOr<void> Function(
    PrivateChannel?);

abstract class PrivateChannelPinsUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.privateChannelPinsUpdate;

  @override
  String? customId;

  FutureOr<void> handle(PrivateChannel channel);
}
