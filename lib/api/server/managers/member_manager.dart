import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';

final class MemberManager {
  final Map<String, GuildMember> _members;

  MemberManager(this._members);

  Map<String, GuildMember> get list =>
      Map.fromIterable(_members.entries.where((element) => !element.value.isBot));

  Map<String, GuildMember> get bots =>
      Map.fromIterable(_members.entries.where((element) => element.value.isBot));

  GuildMember? get(String? id) => _members[id];

  GuildMember getOrFail(String id, {String? error}) => _members.values
      .firstWhere((element) => element.id == id, orElse: () => throw error ?? 'Member not found');

  late final int maxInGuild;

  factory MemberManager.fromJson(
      {required RoleManager roles, required List<Map<String, dynamic>> json}) {
    return MemberManager(Map<String, GuildMember>.from(json.fold({}, (value, element) {
      final member = GuildMember.fromJson(roles: roles, member: element);
      return {...value, member.id: member};
    })));
  }
}
