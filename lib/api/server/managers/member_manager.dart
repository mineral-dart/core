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

  void add(Member member) {
    _members[member.id] = member;
  }

  void remove(String id) {
    _members.remove(id);
  }

  late final int maxInGuild;
}
