import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/parts/role_part.dart';

final class MemberRoleManager {
  RolePart get _roleMethods => DataStore.singleton().role;

  late final Server server;
  late final Member member;
  final Map<Snowflake, Role> _roles;

  Map<Snowflake, Role> get list => _roles;

  MemberRoleManager(this._roles);

  Future<void> add({List<Snowflake>? many, Snowflake? only, String? reason}) async {
    final List<Snowflake> ids = [];

    if (many != null) {
      ids.addAll(many);
    }

    if (only != null) {
      ids.add(only);
    }

    return _roleMethods.addRoles(
        memberId: member.id, serverId: server.id, roleIds: ids, reason: reason);
  }

  factory MemberRoleManager.fromList(List<Role> payload) {
    final roles = Map<Snowflake, Role>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return MemberRoleManager(roles);
  }
}
