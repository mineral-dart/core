import 'dart:async';

import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateChannelCreateEventHandler = FutureOr<void> Function(
  PrivateChannel,
);

abstract class PrivateChannelCreateEvent implements ListenableEvent {
  @override
  String? customId;

  FutureOr<void> handle(
    PrivateChannel channel,
  );
}
