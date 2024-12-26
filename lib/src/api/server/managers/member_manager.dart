import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';

final class MemberManager {
  final Map<Snowflake, Member> _members = {};

  MemberManager();

  Map<Snowflake, Member> get list => _members;

  Map<Snowflake, Member> get humans {
    return _members.entries.where((element) => !element.value.isBot).fold({},
        (value, element) {
      return {...value, element.key: element.value};
    });
  }

  Map<Snowflake, Member> get bots {
    return _members.entries.where((element) => element.value.isBot).fold({},
        (value, element) {
      return {...value, element.key: element.value};
    });
  }

  Member? get(String? id) => _members[id != null ? Snowflake(id) : null];

  Member getOrFail(String id, {String? error}) =>
      _members.values.firstWhere((element) => element.id.value == id,
          orElse: () => throw error ?? 'Member not found');

  late final int maxInGuild;

  factory MemberManager.fromList(List<Member> payload) {
    final members =
        Map<Snowflake, Member>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return MemberManager();
  }
}
