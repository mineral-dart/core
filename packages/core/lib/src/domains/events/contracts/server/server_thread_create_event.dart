import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerThreadCreateEventHandler = FutureOr<void> Function(
    Server, ThreadChannel);

abstract class ServerThreadCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverThreadCreate;

  FutureOr<void> handle(Server server, ThreadChannel channel);
}
