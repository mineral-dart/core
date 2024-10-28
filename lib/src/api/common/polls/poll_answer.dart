import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/infrastructure/commons/helper.dart';

final class PollAnswer {
  Snowflake id;
  String content;
  PartialEmoji? emoji;

  PollAnswer({required this.content, Snowflake? id, this.emoji})
      : id = id ?? Snowflake('');

  Map<String, dynamic> toJson() {
    return {
      'poll_media': {
        'text': content,
        ...?Helper.createOrNull(
            field: emoji,
            fn: () => {
                  'emoji': {
                    'id': emoji?.id,
                    'name': emoji?.name,
                  },
                })
      }
    };
  }
}
