import 'dart:async';

import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerRuleUpdateEventHandler = FutureOr<void> Function(
    AutoModerationRule?, AutoModerationRule);

abstract class ServerRuleUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverRuleUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(AutoModerationRule? before, AutoModerationRule after);
}
