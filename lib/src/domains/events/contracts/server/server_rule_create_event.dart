import 'dart:async';

import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRuleCreateEventHandler = FutureOr<void> Function(
    AutoModerationRule);

abstract class ServerRuleCreateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRuleCreate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(AutoModerationRule rule);
}
