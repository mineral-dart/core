import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';

final class MemberManager {
  final Map<Snowflake, Member> _members;

  MemberManager(this._members);

  Map<Snowflake, Member> get list {
    return _members.entries.where((element) => !element.value.isBot).fold({}, (value, element) {
      return {...value, element.key: element.value};
    });
  }

  Map<Snowflake, Member> get bots {
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

  factory MemberManager.fromList(List<Member> payload) {
    final members = Map<Snowflake, Member>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return MemberManager(members);
  }
}
