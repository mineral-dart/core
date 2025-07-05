import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteAddEventHandler = FutureOr<void> Function(PollAnswerVote<Message>, User);

abstract class ServerPollVoteAddEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteAdd;

  @override
  String? customId;

  FutureOr<void> handle(PollAnswerVote<Message> answer, User user);
}
