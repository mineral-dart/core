import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateChannelDeleteEventHandler = FutureOr<void> Function(PrivateChannel);

abstract class PrivateChannelDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.privateChannelDelete;

  FutureOr<void> handle(PrivateChannel channel);
}