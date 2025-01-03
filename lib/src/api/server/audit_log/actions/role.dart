import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class RoleCreateAuditLog extends AuditLog {
  final List<Change> changes;

  String get roleName => changes.firstWhere((element) => element.key == 'name').after;

  Permissions get rolePermissions =>
      Permissions.fromInt(changes.firstWhere((element) => element.key == 'permissions').after);

  Color get roleColor => Color.of(changes.firstWhere((element) => element.key == 'color').after);

  bool get isHoist => changes.firstWhere((element) => element.key == 'hoist').after;

  bool get isMentionable => changes.firstWhere((element) => element.key == 'mentionable').after;

  RoleCreateAuditLog(
      {required Snowflake serverId, required Snowflake userId, required this.changes})
      : super(AuditLogType.roleCreate, serverId, userId);

  factory RoleCreateAuditLog.fromJson(Map<String, dynamic> json) {
    return RoleCreateAuditLog(
        serverId: json['guild_id'],
        userId: json['user_id'],
        changes: List<Map<String, dynamic>>.from(json['changes']).map(Change.fromJson).toList());
  }
}

final class RoleUpdateAuditLog extends AuditLog {
  final List<Change> changes;

  Change get roleName => changes.firstWhere((element) => element.key == 'name');

  Change<List<Permission>, List<Permission>>? get rolePermissions {
    final permissions = changes.firstWhereOrNull((element) => element.key == 'permissions');
    return switch (permissions) {
      final Change change => Change(
          change.key,
          Permissions.fromInt(change.before).list,
          Permissions.fromInt(change.after).list,
        ),
      _ => null,
    };
  }

  Change<Color, Color>? get roleColor => _resolveParameterOrNull<Color, int>('color', Color.of);

  Change<bool, bool>? get isHoist => _resolveParameterOrNull<bool, String>('hoist', bool.parse);

  Change<bool, bool>? get isMentionable => _resolveParameterOrNull<bool, String>('mentionable', bool.parse);

  Change<T, T>? _resolveParameterOrNull<T, S>(String key, T Function(S) transformer) {
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

  RoleUpdateAuditLog(
      {required Snowflake serverId, required Snowflake userId, required this.changes})
      : super(AuditLogType.roleCreate, serverId, userId);

  factory RoleUpdateAuditLog.fromJson(Map<String, dynamic> json) {
    return RoleUpdateAuditLog(
        serverId: json['guild_id'],
        userId: json['user_id'],
        changes: List<Map<String, dynamic>>.from(json['changes']).map(Change.fromJson).toList());
  }
}

final class RoleDeleteAuditLog extends AuditLog {
  final String roleName;

  RoleDeleteAuditLog(
      {required Snowflake serverId, required Snowflake userId, required this.roleName})
      : super(AuditLogType.emojiDelete, serverId, userId);

  factory RoleDeleteAuditLog.fromJson(Map<String, dynamic> json) {
    return RoleDeleteAuditLog(
        serverId: json['guild_id'],
        roleName: json['changes'][0]['old_value'],
        userId: json['user_id']);
  }
}
