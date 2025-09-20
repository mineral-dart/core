import 'dart:async';

import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRuleCreateEventHandler = FutureOr<void> Function(AutoModerationRule);

abstract class ServerRuleCreateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRuleCreate;

  @override
  String? customId;

  FutureOr<void> handle(AutoModerationRule rule);
}
