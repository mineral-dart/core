import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';

typedef ReadyEventHandler = FutureOr<void> Function(Bot bot);

abstract class ReadyEvent implements ListenableEvent {
  @override
  String get event => 'ReadyEvent';

  FutureOr<void> handle(Bot bot);
}
