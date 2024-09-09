import 'dart:async';

import 'package:mineral/src/api/common/bot.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent implements ListenableEvent {
  @override
  Event get event => Event.ready;

  @override
  String? customId;

  FutureOr<void> handle(Bot bot);
}
