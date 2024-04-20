import 'package:mineral/api/common/partial_emoji.dart';

final class PollQuestion {
  String content;
  PartialEmoji? emoji;

  PollQuestion({required this.content, this.emoji});
}
