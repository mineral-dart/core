import 'dart:async';

import 'package:mineral/domains/data/types/listenable_event.dart';

abstract class MessageCreateEvent implements ListenableEvent {
  @override
  String get event => 'MessageCreateEvent';

  FutureOr<void> handle();
}
