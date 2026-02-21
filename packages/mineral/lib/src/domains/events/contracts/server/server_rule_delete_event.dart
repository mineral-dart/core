import 'dart:async';

import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRuleDeleteEventHandler = FutureOr<void> Function(AutoModerationRule);

abstract class ServerRuleDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRuleDelete;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(AutoModerationRule rule);
}
