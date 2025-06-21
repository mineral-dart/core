import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/webhook.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> webhookCreateAuditLogHandler(Map<String, dynamic> json) async {
  return WebhookCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    webhookId: Snowflake.parse(json['target_id']),
    webhookName: json['changes'][0]['new_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> webhookUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return WebhookUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    webhookId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> webhookDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return WebhookDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    webhookId: Snowflake.parse(json['target_id']),
    webhookName: json['changes'][0]['old_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}
