import 'package:mineral/src/api/emoji.dart';

class EmojiBuilder {
  PartialEmoji emoji;

  EmojiBuilder(this.emoji);

  factory EmojiBuilder.fromUnicode(String label) => EmojiBuilder(PartialEmoji('', label, false));
  factory EmojiBuilder.fromEmoji(Emoji emoji) => EmojiBuilder(emoji);
}