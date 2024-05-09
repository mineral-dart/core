import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.ready;

  FutureOr<void> handle(Bot bot);
}
