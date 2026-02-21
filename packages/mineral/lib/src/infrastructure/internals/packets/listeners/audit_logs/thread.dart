import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/thread.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> threadCreateAuditLogHandler(Map<String, dynamic> json) async {
  return ThreadCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    threadId: Snowflake.parse(json['target_id']),
    threadName: json['changes'][0]['new_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> threadUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return ThreadUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    threadId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> threadDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return ThreadDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    threadId: Snowflake.parse(json['target_id']),
    threadName: json['changes'][0]['old_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}
