import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/role_part.dart';

final class MemberRoleManager {
  RolePart get _roleMethods => ioc.resolve<DataStoreContract>().role;

  late final Server server;
  late final Member member;
  final Map<Snowflake, Role> _roles;

  Map<Snowflake, Role> get list => _roles;

  MemberRoleManager(this._roles);

  Future<void> add(Snowflake roleId, {String? reason}) async {
    return _roleMethods.addRole(
        memberId: member.id,
        serverId: server.id,
        roleId: roleId,
        reason: reason);
  }

  Future<void> remove(Snowflake roleId, {String? reason}) async {
    return _roleMethods.removeRole(
        memberId: member.id,
        serverId: server.id,
        roleId: roleId,
        reason: reason);
  }

  Future<void> sync(List<Snowflake> roleIds, {String? reason}) async {
    return _roleMethods.syncRoles(
        memberId: member.id,
        serverId: server.id,
        roleIds: roleIds,
        reason: reason);
  }

  Future<void> clear({String? reason}) async {
    return _roleMethods.syncRoles(
        memberId: member.id, serverId: server.id, roleIds: [], reason: reason);
  }

  factory MemberRoleManager.fromList(List<Role> payload) {
    final roles = Map<Snowflake, Role>.from(payload.fold({}, (value, element) {
      return {...value, element.id: element};
    }));

    return MemberRoleManager(roles);
  }
}
