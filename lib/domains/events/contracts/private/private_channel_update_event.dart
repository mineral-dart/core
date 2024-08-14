import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateChannelUpdateEventHandler = FutureOr<void> Function(PrivateChannel);

abstract class PrivateChannelUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.privateChannelUpdate;

  @override
  String? customId;

  FutureOr<void> handle(PrivateChannel channel);
}
