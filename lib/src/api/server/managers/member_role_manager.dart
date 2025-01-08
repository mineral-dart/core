import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/role.dart';
import 'package:mineral/src/api/server/server.dart';

final class MemberRoleManager {
  RolePartContract get _roleMethods => ioc.resolve<DataStoreContract>().role;

  late final Server server;
  late final Member member;
  final Map<Snowflake, Role> _roles;

  Map<Snowflake, Role> get list => _roles;

  MemberRoleManager(this._roles);

  Future<void> add(String roleId, {String? reason}) async {
    return _roleMethods.add(
        memberId: member.id.value, serverId: server.id.value, roleId: roleId, reason: reason);
  }

  Future<void> remove(String roleId, {String? reason}) async {
    return _roleMethods.remove(
        memberId: member.id.value, serverId: server.id.value, roleId: roleId, reason: reason);
  }

  Future<void> sync(List<String> roleIds, {String? reason}) async {
    return _roleMethods.sync(
        memberId: member.id.value, serverId: server.id.value, roleIds: roleIds, reason: reason);
  }

  Future<void> clear({String? reason}) async {
    return _roleMethods.sync(
        memberId: member.id.value, serverId: server.id.value, roleIds: [], reason: reason);
  }

  factory MemberRoleManager.fromList(List<Role> payload) {
    final roles = Map<Snowflake, Role>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return MemberRoleManager(roles);
  }
}
