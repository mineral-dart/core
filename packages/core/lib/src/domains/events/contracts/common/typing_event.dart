import 'dart:async';

import 'package:mineral/src/api/common/typing.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef TypingEventHandler = FutureOr<void> Function(Typing typing);

abstract class TypingEvent extends BaseListenableEvent {
  @override
  Event get event => Event.typing;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Typing typing);
}
