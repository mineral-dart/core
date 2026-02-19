import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRuleExecutionEventHandler = FutureOr<void> Function(RuleExecution);

abstract class ServerRuleExecutionEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRuleExecution;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(RuleExecution execution);
}
