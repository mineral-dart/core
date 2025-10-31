import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class MemberRoleManager {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final List<Snowflake> currentIds;
  final Snowflake _serverId;
  final Snowflake _memberId;

  MemberRoleManager(this.currentIds, this._serverId, this._memberId);

  Future<Map<Snowflake, Role>> fetch({bool force = false}) async {
    final roles = await _datastore.role.fetch(_serverId.value, force);
    return Map.fromEntries(
      roles.entries
          .where((element) => currentIds.contains(element.key))
          .map((e) => MapEntry(e.key, e.value)),
    );
  }

  Future<void> add(String roleId, {String? reason}) async {
    return _datastore.role.add(
      memberId: _memberId.value,
      serverId: _serverId.value,
      roleId: roleId,
      reason: reason,
    );
  }

  Future<void> remove(String roleId, {String? reason}) async {
    return _datastore.role.remove(
      memberId: _memberId.value,
      serverId: _serverId.value,
      roleId: roleId,
      reason: reason,
    );
  }

  Future<void> sync(List<String> roleIds, {String? reason}) async {
    return _datastore.role.sync(
      memberId: _memberId.value,
      serverId: _serverId.value,
      roleIds: roleIds,
      reason: reason,
    );
  }

  Future<void> clear({String? reason}) async {
    return _datastore.role.sync(
      memberId: _memberId.value,
      serverId: _serverId.value,
      roleIds: [],
      reason: reason,
    );
  }
}
