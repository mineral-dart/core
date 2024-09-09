import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/role.dart';

final class EmojiManager {
  final Map<Snowflake, Emoji> _emojis;

  EmojiManager(this._emojis);

  Map<Snowflake, Emoji> get list => _emojis;

  factory EmojiManager.fromList(List<Role> roles, List<Emoji> emojis) {
    return EmojiManager(
        Map<Snowflake, Emoji>.from(emojis.fold({}, (value, element) {
      return {...value, element.id: element};
    })));
  }
}
