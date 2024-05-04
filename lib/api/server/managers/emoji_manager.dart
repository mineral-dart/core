import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

final class EmojiManager {
  final Map<Snowflake, Emoji> _emojis;

  EmojiManager(this._emojis);

  Map<Snowflake, Emoji> get list => _emojis;

  factory EmojiManager.fromJson(MarshallerContract marshaller,
      {required List<Role> roles, required List<dynamic> payload}) {
    return EmojiManager(Map<Snowflake, Emoji>.from(payload.fold({}, (value, element) {
      final emoji = marshaller.serializers.emojis.serialize({
        'guildRoles': roles,
        ...element,
      }) as Emoji;

      return {...value, emoji.id: emoji};
    })));
  }
}
