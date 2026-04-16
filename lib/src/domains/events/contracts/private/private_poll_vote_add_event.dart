import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivatePollVoteAddEventHandler = FutureOr<void> Function(
    PollAnswerVote<Message>, User);

abstract class PrivatePollVoteAddEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privatePollVoteAdd;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PollAnswerVote<Message> answer, User user);
}
