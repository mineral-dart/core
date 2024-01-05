import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/server/managers/role_manager.dart';

final class EmojiManager {
  final Map<String, Emoji> _emojis;

  EmojiManager(this._emojis);

  Map<String, Emoji> get list => _emojis;

  factory EmojiManager.fromJson({required RoleManager roles, required List<dynamic> json}) {
    return EmojiManager(Map<String, Emoji>.from(json.fold({}, (value, element) {
      final member = Emoji.fromJson(guildRoles: roles.list, json: element);
      return {...value, member.id: member};
    })));
  }
}
