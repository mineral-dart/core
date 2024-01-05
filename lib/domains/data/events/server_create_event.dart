import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';

typedef ServerCreateEventHandler = FutureOr<void> Function(Bot bot);

abstract class ServerCreateEvent implements ListenableEvent {
  @override
  String get event => 'ServerCreateEvent';

  FutureOr<void> handle(Server server);
}
