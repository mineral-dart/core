import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteAddEventHandler = FutureOr<void> Function(Server, Message, int);

abstract class ServerPollVoteAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteAdd;

  @override
  String? customId;

  FutureOr<void> handle(Server server, Message message, int answerId);
}
