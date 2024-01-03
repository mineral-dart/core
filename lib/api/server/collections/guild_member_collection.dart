import 'package:mineral/api/server/collections/role_collection.dart';
import 'package:mineral/api/server/guild_member.dart';

final class GuildMemberCollection {
  final Map<String, GuildMember> _members;

  GuildMemberCollection(this._members);

  Map<String, GuildMember> get list => _members;

  GuildMember? get(String? id) => _members[id];

  GuildMember getOrFail(String id, {String? error}) => _members.values
      .firstWhere((element) => element.id == id, orElse: () => throw error ?? 'Member not found');

  factory GuildMemberCollection.fromJson(
      {required String guildId,
      required RoleCollection roles,
      required List<Map<String, dynamic>> json}) {
    return GuildMemberCollection(Map<String, GuildMember>.from(json.fold({}, (value, element) {
      final member = GuildMember.fromJson(roles: roles, member: element, guildId: guildId);
      return {...value, member.id: member};
    })));
  }
}
