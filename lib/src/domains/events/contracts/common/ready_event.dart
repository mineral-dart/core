import 'dart:async';

import 'package:mineral/src/api/common/bot/bot.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent extends BaseListenableEvent {
  @override
  Event get event => Event.ready;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Bot bot);
}
