import 'package:mineral/api/common/polls/poll_answer.dart';
import 'package:mineral/api/common/polls/poll_layout.dart';
import 'package:mineral/api/common/polls/poll_question.dart';

final class Poll {
  final PollQuestion question;
  final List<PollAnswer> answers;
  final Duration? expireAt;
  final bool isAllowMultiple;
  final PollLayout layout;

  Poll({
    required this.question,
    required this.answers,
    required this.expireAt,
    required this.isAllowMultiple,
    this.layout = PollLayout.initial,
  });
}
