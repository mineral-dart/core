import 'package:mineral/api/common/emojis/unicode_emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';
import 'package:mineral/api/server/custom_emoji.dart';

class Emoji implements EmojiContract {
  @override
  String label;

  Emoji._(this.label);

  factory Emoji.unicode(String label) => UnicodeEmoji(label);

  factory Emoji.custom({
    required String label,
    required Snowflake id,
    required bool isAnimated,
    required bool isManaged,
  }) => CustomEmoji(
    label: label,
    id: id,
    isAnimated: isAnimated,
    isManaged: isAnimated,
  );

  factory Emoji.fromWss(Map<String, dynamic> payload) {
    return payload['id'] != null ? CustomEmoji.from(payload) : UnicodeEmoji(payload['name']);
  }

  @override
  String toString() => label;
}