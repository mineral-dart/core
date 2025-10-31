import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerChannelCreateEventHandler = FutureOr<void> Function(
  ServerChannel channel,
);

abstract class ServerChannelCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelCreate;

  @override
  String? customId;

  FutureOr<void> handle(
    ServerChannel channel,
  );
}
