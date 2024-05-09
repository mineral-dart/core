import 'package:mineral/api/common/partial_emoji.dart';
import 'package:mineral/infrastructure/commons/helper.dart';

final class PollAnswer {
  String content;
  PartialEmoji? emoji;

  PollAnswer({required this.content, this.emoji});

  Map<String, dynamic> toJson() {
    return {
      'poll_media': {
        'text': content,
        ...?Helper.createOrNull(field: emoji, fn: () => {
          'emoji': {
            'id': emoji?.id,
            'name': emoji?.name,
          },
        })
      }
    };
  }
}
