import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/polls/poll_answer.dart';
import 'package:mineral/src/api/common/polls/poll_layout.dart';
import 'package:mineral/src/api/common/polls/poll_question.dart';

final class PollBuilder {
  PollQuestion? _question;
  final List<PollAnswer> _answers = [];
  Duration? _expireAt;
  bool _isMultipleResponsesAllowed = false;
  PollLayout _layout = PollLayout.initial;

  PollBuilder setQuestion({required String question, PartialEmoji? emoji}) {
    _question = PollQuestion(content: question, emoji: emoji);
    return this;
  }

  PollBuilder addAnswer({required String answer, PartialEmoji? emoji}) {
    _answers.add(PollAnswer(content: answer, emoji: emoji));
    return this;
  }

  PollBuilder setExpireAt(Duration expireAt) {
    _expireAt = expireAt;
    return this;
  }

  PollBuilder allowMultipleResponses(bool value) {
    _isMultipleResponsesAllowed = value;
    return this;
  }

  PollBuilder setLayout(PollLayout layout) {
    _layout = layout;
    return this;
  }

  Poll build() {
    if (_question == null) {
      throw Exception('Question is required');
    }

    return Poll(
      question: _question!,
      answers: _answers,
      expireAt: _expireAt,
      isMultipleResponseAllowed: _isMultipleResponsesAllowed,
      layout: _layout,
    );
  }
}
