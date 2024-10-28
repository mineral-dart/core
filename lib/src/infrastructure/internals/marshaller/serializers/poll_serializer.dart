import 'dart:convert';

import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/polls/poll_answer.dart';
import 'package:mineral/src/api/common/polls/poll_layout.dart';
import 'package:mineral/src/api/common/polls/poll_question.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/infrastructure/commons/helper.dart';
import 'package:mineral/src/infrastructure/commons/utils.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class PollSerializer implements SerializerContract<Poll> {
  final MarshallerContract _marshaller;

  PollSerializer(this._marshaller);

  @override
  Map<String, dynamic> normalize(Map<String, dynamic> json) {
    print(jsonEncode(json));
    return {
      'message_id': json['message_id'],
      'question_text': json['question']['text'],
      'answers': List.from(json['answers'])
          .map((element) => {
                'text': element['poll_media']['text'],
                'id': element['poll_media']['id'],
              })
          .toList(),
      'expiry': json['expiry'],
      'allow_multiselect': json['allow_multiselect'],
      'layout_type': json['layout_type'],
    };
  }

  @override
  Poll serialize(Map<String, dynamic> json) {
    return Poll(
        messageId:
            json['message_id'] != null ? Snowflake(json['message_id']) : null,
        question: PollQuestion(content: json['question_text']),
        answers: List.from(json['answers'])
            .map((element) => PollAnswer(
                id: element['id'] != null ? Snowflake(element['id']) : null,
                content: element['text'],
                emoji: Helper.createOrNull(
                    field: element['emoji'],
                    fn: () => PartialEmoji.fromUnicode(element['emoji']))))
            .toList(),
        expireAt: Helper.createOrNull(
            field: json['expiry'],
            fn: () =>
                DateTime.parse(json['expiry']).difference(DateTime.now())),
        isAllowMultiple: json['allow_multiselect'],
        layout: findInEnum(PollLayout.values, json['layout_type']));
  }

  @override
  Map<String, dynamic> deserialize(Poll poll) {
    final answers = poll.answers.map((element) {
      return {
        'id': element.id,
        'emoji': element.emoji,
        'text': element.content,
      };
    }).toList();

    return {
      'message_id': poll.messageId,
      'question_text': poll.question.content,
      'answers': answers,
      'expiry': poll.expireAt?.inMilliseconds,
      'allow_multiselect': poll.isAllowMultiple,
      'layout_type': poll.layout.value,
    };
  }
}
