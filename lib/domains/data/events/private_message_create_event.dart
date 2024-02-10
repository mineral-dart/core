import 'dart:async';

import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef PrivateMessageEventHandler = FutureOr<void> Function(PrivateMessage message);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.privateMessageCreate;

  FutureOr<void> handle(Server server);
}
