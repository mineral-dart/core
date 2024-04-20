import 'package:mineral/api/common/partial_emoji.dart';

final class PollAnswer {
  String content;
  PartialEmoji? emoji;

  PollAnswer({required this.content, this.emoji});

  Map<String, dynamic> toJson() {
    return {
      'poll_media': {
        'text': content,
      }
    };
  }
}
