import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/server/collections/role_collection.dart';

final class GuildEmojiCollection {
  final Map<String, Emoji> _emojis;

  GuildEmojiCollection(this._emojis);

  Map<String, Emoji> get list => _emojis;

  factory GuildEmojiCollection.fromJson(
      {required RoleCollection roles, required List<dynamic> json}) {
    return GuildEmojiCollection(Map<String, Emoji>.from(json.fold({}, (value, element) {
      final member = Emoji.fromJson(guildRoles: roles.list, json: element);
      return {...value, member.id: member};
    })));
  }
}
