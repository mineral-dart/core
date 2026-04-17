import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/integration.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> integrationCreateAuditLogHandler(
    Map<String, dynamic> json) async {
  return IntegrationCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    integrationId: Snowflake.parse(json['target_id']),
    integrationType: json['options']?['type'] as String? ?? 'unknown',
  );
}

Future<AuditLog> integrationUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return IntegrationUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    integrationId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'] as Iterable<dynamic>)
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> integrationDeleteAuditLogHandler(
    Map<String, dynamic> json) async {
  return IntegrationDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    integrationId: Snowflake.parse(json['target_id']),
    integrationType: json['options']?['type'] as String? ?? 'unknown',
  );
}
