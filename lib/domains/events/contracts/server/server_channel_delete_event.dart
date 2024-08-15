import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerChannelDeleteEventHandler = FutureOr<void> Function(ServerChannel?);

abstract class ServerChannelDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelDelete;

  @override
  String? customId;

  FutureOr<void> handle(ServerChannel? channel);
}
