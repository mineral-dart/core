import 'package:mineral/src/api/builders/emoji_builder.dart';

class ForumTagBuilder {
  final String label;
  final bool moderated;
  final EmojiBuilder? emoji;

  ForumTagBuilder({
    required this.label,
    required this.moderated,
    this.emoji,
  });

  Object toJson () {
    final json = {
      'name': label,
      'moderated': moderated,
    };

    if (emoji is EmojiBuilder && emoji!.emoji.label.isNotEmpty) {
      json.putIfAbsent('emoji_name', () => emoji!.emoji.label);
    }

    if (emoji is EmojiBuilder && emoji!.emoji.id.isNotEmpty) {
      json.putIfAbsent('emoji_id', () => emoji!.emoji.id);
    }

    return json;
  }
}
