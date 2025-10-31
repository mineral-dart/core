import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivatePollVoteRemoveEventHandler = FutureOr<void> Function(
  PollAnswerVote<Message>,
  User,
);

abstract class PrivatePollVoteRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.privatePollVoteRemove;

  @override
  String? customId;

  FutureOr<void> handle(
    PollAnswerVote<Message> answer,
    User user,
  );
}
