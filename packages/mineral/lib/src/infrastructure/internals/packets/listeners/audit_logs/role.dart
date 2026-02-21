import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> roleCreateAuditLogHandler(Map<String, dynamic> json) async {
  return RoleCreateAuditLog(
      serverId: json['guild_id'],
      userId: json['user_id'],
      changes: List<Map<String, dynamic>>.from(json['changes'])
          .map(Change.fromJson)
          .toList(),
      roleId: json['target_id']);
}

Future<AuditLog> roleUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return RoleUpdateAuditLog(
      serverId: json['guild_id'],
      userId: json['user_id'],
      roleId: json['target_id'],
      changes: List<Map<String, dynamic>>.from(json['changes'])
          .map(Change.fromJson)
          .toList());
}

Future<AuditLog> roleDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return RoleDeleteAuditLog(
      serverId: json['guild_id'],
      roleName: json['changes'][0]['old_value'],
      userId: json['user_id'],
      roleId: json['target_id']);
}
