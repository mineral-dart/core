import 'dart:async';

import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateChannelCreateEventHandler = FutureOr<void> Function(PrivateChannel);

abstract class PrivateChannelCreateEvent implements ListenableEvent {
  @override
  String? customId;

  FutureOr<void> handle(PrivateChannel channel);
}
