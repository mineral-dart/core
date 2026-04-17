import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerThreadUpdateEventHandler = FutureOr<void> Function(
    Server, ThreadChannel?, ThreadChannel);

abstract class ServerThreadUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverThreadUpdate;

  FutureOr<void> handle(
      Server server, ThreadChannel before, ThreadChannel after);
}
