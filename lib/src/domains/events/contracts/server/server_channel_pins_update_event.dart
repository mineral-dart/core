import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerChannelPinsUpdateEventHandler = FutureOr<void> Function(
  Server,
  ServerChannel?,
);

abstract class ServerChannelPinsUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelPinsUpdate;

  @override
  String? customId;

  FutureOr<void> handle(
    Server server,
    ServerChannel channel,
  );
}
