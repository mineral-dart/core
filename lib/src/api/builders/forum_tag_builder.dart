import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/emoji_builder.dart';

/// Tag builder for [ForumChannel].
class ForumTagBuilder {
  /// Name of this.
  final String label;

  /// Is this moderated
  final bool moderated;

  /// Emoji of this.
  final EmojiBuilder? emoji;

  ForumTagBuilder({
    required this.label,
    required this.moderated,
    this.emoji,
  });

  /// Serialize this to json.
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
