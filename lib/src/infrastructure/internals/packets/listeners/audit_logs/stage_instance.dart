import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/stage_instance.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> stageInstanceCreateAuditLogHandler(
    Map<String, dynamic> json) async {
  return StageInstanceCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stageInstanceId: Snowflake.parse(json['target_id']),
    topic: json['changes'][0]['new_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> stageInstanceUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return StageInstanceUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stageInstanceId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> stageInstanceDeleteAuditLogHandler(
    Map<String, dynamic> json) async {
  return StageInstanceDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stageInstanceId: Snowflake.parse(json['target_id']),
    topic: json['changes'][0]['old_value'],
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}
