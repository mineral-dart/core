import 'dart:async';

import 'package:mineral/src/api/common/typing.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef TypingEventHandler = FutureOr<void> Function(Typing typing);

abstract class TypingEvent implements ListenableEvent {
  @override
  Event get event => Event.typing;

  @override
  String? customId;

  FutureOr<void> handle(Typing typing);
}
