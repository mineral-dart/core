import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/channel_overwrite.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> channelOverwriteCreateAuditLogHandler(
    Map<String, dynamic> json) async {
  return ChannelOverwriteCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    channelId:
        Snowflake.parse(json['options']?['channel_id'] ?? json['target_id']),
    overwriteId: Snowflake.parse(json['target_id']),
    overwriteType: json['options']?['type'] ?? 'role',
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> channelOverwriteUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return ChannelOverwriteUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    channelId:
        Snowflake.parse(json['options']?['channel_id'] ?? json['target_id']),
    overwriteId: Snowflake.parse(json['target_id']),
    overwriteType: json['options']?['type'] ?? 'role',
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> channelOverwriteDeleteAuditLogHandler(
    Map<String, dynamic> json) async {
  return ChannelOverwriteDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    channelId:
        Snowflake.parse(json['options']?['channel_id'] ?? json['target_id']),
    overwriteId: Snowflake.parse(json['target_id']),
    overwriteType: json['options']?['type'] ?? 'role',
  );
}
