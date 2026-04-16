import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRuleExecutionEventHandler = FutureOr<void> Function(
    RuleExecution);

abstract class ServerRuleExecutionEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRuleExecution;

  @override
  Function get handler => handle;

  FutureOr<void> handle(RuleExecution execution);
}
