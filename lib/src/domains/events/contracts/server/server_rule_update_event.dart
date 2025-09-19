import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerRuleUpdateEventHandler = FutureOr<void> Function(AutoModerationRule?, AutoModerationRule);

abstract class ServerRuleUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverRuleUpdate;

  @override
  String? customId;

  FutureOr<void> handle(AutoModerationRule? before, AutoModerationRule after);
}
