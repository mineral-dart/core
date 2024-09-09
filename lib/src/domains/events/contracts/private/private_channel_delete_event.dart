import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateChannelDeleteEventHandler = FutureOr<void> Function(
    PrivateChannel);

abstract class PrivateChannelDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.privateChannelDelete;

  @override
  String? customId;

  FutureOr<void> handle(PrivateChannel channel);
}
