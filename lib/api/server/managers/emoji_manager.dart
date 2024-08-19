import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class EmojiManager {
  final Map<Snowflake, Emoji> _emojis;

  EmojiManager(this._emojis);

  Map<Snowflake, Emoji> get list => _emojis;

  factory EmojiManager.fromList(List<Role> roles, List<Emoji> emojis) {
    return EmojiManager(Map<Snowflake, Emoji>.from(emojis.fold({}, (value, element) {
      return {...value, element.id: element};
    })));
  }
}
