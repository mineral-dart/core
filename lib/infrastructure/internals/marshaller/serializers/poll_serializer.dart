import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/polls/poll_answer.dart';
import 'package:mineral/api/common/polls/poll_layout.dart';
import 'package:mineral/api/common/polls/poll_question.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class PollSerializer implements SerializerContract<Poll> {
  final MarshallerContract _marshaller;

  PollSerializer(this._marshaller);

  @override
  Poll serializeRemote(Map<String, dynamic> json) {
    return Poll(
        question: PollQuestion(content: json['question']['text']),
        answers: List.from(json['answers'])
            .map((element) => PollAnswer(content: element['text']))
            .toList(),
        expireAt:
            Helper.createOrNull(field: json['expiry'], fn: () => DateTime.parse(json['expiry']).difference(DateTime.now())),
        isAllowMultiple: json['allow_multiselect'],
        layout: findInEnum(PollLayout.values, json['layout_type']));
  }

  @override
  Future<Poll> serializeCache(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> deserialize(Poll poll) {
    return {
      'question': {
        'text': poll.question.content,
      },
      'answers': poll.answers.map((e) => e.toJson()).toList(),
      'duration': poll.expireAt?.inHours,
      'allow_multiselect': poll.isAllowMultiple,
      'layout_type': poll.layout.value,
    };
  }
}
