import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';

final class MemberManager {
  final Map<String, Member> _members;

  MemberManager(this._members);

  Map<String, Member> get list {
    return _members.entries.where((element) => !element.value.isBot).fold({}, (value, element) {
      return {...value, element.key: element.value};
    });
  }

  Map<String, Member> get bots {
    return _members.entries.where((element) => !element.value.isBot).fold({}, (value, element) {
      return {...value, element.key: element.value};
    });
  }

  Member? get(String? id) => _members[id];

  Member getOrFail(String id, {String? error}) => _members.values
      .firstWhere((element) => element.id == id, orElse: () => throw error ?? 'Member not found');

  late final int maxInGuild;

  factory MemberManager.fromJson({required RoleManager roles, required List<dynamic> json}) {
    return MemberManager(Map<String, Member>.from(json.fold({}, (value, element) {
      final member = Member.fromJson(roles: roles, member: element);
      return {...value, member.id: member};
    })));
  }
}
