import 'package:mineral/src/api/emoji.dart';

/// [Emoji] builder
class EmojiBuilder {
  /// Partial [Emoji]
  PartialEmoji emoji;

  EmojiBuilder(this.emoji);

  /// Create [EmojiBuilder] from unicode
  factory EmojiBuilder.fromUnicode(String label) => EmojiBuilder(PartialEmoji('', label, false));

  /// Create [EmojiBuilder] from [Emoji]
  factory EmojiBuilder.fromEmoji(Emoji emoji) => EmojiBuilder(emoji);
}