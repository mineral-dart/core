import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent implements ListenableEvent {
  @override
  EventList get event => MineralEvent.ready;

  FutureOr<void> handle(Bot bot);
}
