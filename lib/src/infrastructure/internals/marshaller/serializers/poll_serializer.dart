import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/polls/poll_answer.dart';
import 'package:mineral/src/api/common/polls/poll_layout.dart';
import 'package:mineral/src/api/common/polls/poll_question.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';
import 'package:mineral/src/domains/common/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class PollSerializer implements SerializerContract<Poll> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'message_id': json['message_id'],
      'question_text': json['question']['text'],
      'answers':
          List.from(json['answers']).map((element) => element['text']).toList(),
      'expiry': json['expiry'],
      'allow_multiselect': json['allow_multiselect'],
      'layout_type': json['layout_type'],
    };

    final cacheKey = _marshaller.cacheKey.poll(json['message_id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Poll serialize(Map<String, dynamic> json) {
    return Poll(
        messageId: Snowflake.nullable(json['message_id']),
        question: PollQuestion(content: json['question_text']),
        answers: List.from(json['answers'])
            .map((element) => PollAnswer(
                content: element['text'],
                emoji: Helper.createOrNull(
                    field: element['emoji'],
                    fn: () => PartialEmoji.fromUnicode(element['emoji']))))
            .toList(),
        expireAt: Helper.createOrNull(
            field: json['expiry'],
            fn: () =>
                DateTime.parse(json['expiry']).difference(DateTime.now())),
        isMultipleResponseAllowed: json['allow_multiselect'],
        layout: findInEnum(PollLayout.values, json['layout_type']));
  }

  @override
  Map<String, dynamic> deserialize(Poll poll) {
    final answers = poll.answers.map((element) {
      return element.toJson();
    }).toList();

    return {
      'message_id': poll.messageId?.value,
      'question': poll.question.toJson(),
      'question_text': poll.question.content,
      'answers': answers,
      'expiry': poll.expireAt?.inMilliseconds,
      'allow_multiselect': poll.isMultipleResponseAllowed,
      'layout_type': poll.layout.value,
    };
  }
}
