import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> roleCreateAuditLogHandler(Map<String, dynamic> json) async {
  return RoleCreateAuditLog(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      changes: List<Map<String, dynamic>>.from(json['changes'] as Iterable<dynamic>)
          .map(Change.fromJson)
          .toList(),
      roleId: Snowflake.parse(json['target_id']));
}

Future<AuditLog> roleUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return RoleUpdateAuditLog(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      roleId: Snowflake.parse(json['target_id']),
      changes: List<Map<String, dynamic>>.from(json['changes'] as Iterable<dynamic>)
          .map(Change.fromJson)
          .toList());
}

Future<AuditLog> roleDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return RoleDeleteAuditLog(
      serverId: Snowflake.parse(json['guild_id']),
      roleName: (json['changes'] as List<dynamic>)[0]['old_value'] as String,
      userId: Snowflake.parse(json['user_id']),
      roleId: Snowflake.parse(json['target_id']));
}
