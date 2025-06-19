import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class RoleCreateAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake roleId;
  final List<Change> changes;

  String get roleName =>
      changes.firstWhere((element) => element.key == 'name').after;

  Permissions get roleOermissions => Permissions.fromInt(
      changes.firstWhere((element) => element.key == 'permissions').after);

  Color get roleColor =>
      Color.of(changes.firstWhere((element) => element.key == 'color').after);

  bool get roleIsHoist =>
      changes.firstWhere((element) => element.key == 'hoist').after;

  bool get roleIsMentionable =>
      changes.firstWhere((element) => element.key == 'mentionable').after;

  RoleCreateAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.roleId,
      required this.changes})
      : super(AuditLogType.roleCreate, serverId, userId);

  Future<Role> resolveRole({bool force = false}) async {
    final role = await _datastore.role.get(serverId.value, roleId.value, force);
    return role!;
  }
}

final class RoleUpdateAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake roleId;
  final List<Change> changes;

  Change get roleName => changes.firstWhere((element) => element.key == 'name');

  Change<List<Permission>, List<Permission>>? get rolePermissions {
    final permissions =
        changes.firstWhereOrNull((element) => element.key == 'permissions');
    return switch (permissions) {
      final Change change => Change(
          change.key,
          Permissions.fromInt(change.before).list,
          Permissions.fromInt(change.after).list,
        ),
      _ => null,
    };
  }

  Change<Color, Color>? get roleColor =>
      _resolveParameterOrNull<Color, int>('color', Color.of);

  Change<bool, bool>? get roleIsHoist =>
      _resolveParameterOrNull<bool, String>('hoist', bool.parse);

  Change<bool, bool>? get roleIsMentionable =>
      _resolveParameterOrNull<bool, String>('mentionable', bool.parse);

  Change<T, T>? _resolveParameterOrNull<T, S>(
      String key, T Function(S) transformer) {
    final parameter = changes.firstWhereOrNull((element) => element.key == key);
    return switch (parameter) {
      final Change change => Change(
          change.key,
          transformer(change.before),
          transformer(change.after),
        ),
      _ => null,
    };
  }

  Future<Role> resolveRole({bool force = false}) async {
    final role = await _datastore.role.get(serverId.value, roleId.value, force);
    return role!;
  }

  RoleUpdateAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.roleId,
      required this.changes})
      : super(AuditLogType.roleCreate, serverId, userId);
}

final class RoleDeleteAuditLog extends AuditLog {
  final Snowflake roleId;
  final String roleName;

  RoleDeleteAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.roleId,
      required this.roleName})
      : super(AuditLogType.emojiDelete, serverId, userId);
}
