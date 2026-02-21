import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerPollVoteRemoveEventHandler = FutureOr<void> Function(PollAnswerVote<Message>, User);

abstract class ServerPollVoteRemoveEvent implements ListenableEvent {
  @override
  Event get event => Event.serverPollVoteRemove;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PollAnswerVote<Message> message, User user);
}
