import 'dart:async';

import 'package:mineral/domains/events/types/listenable_event.dart';

abstract class ReadyEvent implements ListenableEvent {
  @override
  String get event => 'ReadyEvent';

  FutureOr<void> handle();
}
