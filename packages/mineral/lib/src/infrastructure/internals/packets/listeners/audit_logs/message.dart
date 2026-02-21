import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/message.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> messageDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return MessageDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    messageId: Snowflake.parse(json['target_id']),
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> messageBulkDeleteAuditLogHandler(
    Map<String, dynamic> json) async {
  return MessageBulkDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    count: json['options']?['count'] ?? 0,
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> messagePinAuditLogHandler(Map<String, dynamic> json) async {
  return MessagePinAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    messageId: Snowflake.parse(json['target_id']),
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> messageUnpinAuditLogHandler(Map<String, dynamic> json) async {
  return MessageUnpinAuditLog(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.parse(json['user_id']),
      messageId: Snowflake.parse(json['target_id']),
      channelId: Snowflake.nullable(json['options']?['channel_id']));
}
