import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent implements ListenableEvent {
  @override
  Event get event => Event.ready;

  FutureOr<void> handle(Bot bot);
}