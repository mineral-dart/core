import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/auto_moderation.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> autoModerationRuleCreateAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationRuleCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    ruleId: Snowflake.parse(json['target_id']),
  );
}

Future<AuditLog> autoModerationRuleUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationRuleUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    ruleId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> autoModerationRuleDeleteAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationRuleDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    ruleId: Snowflake.parse(json['target_id']),
  );
}

Future<AuditLog> autoModerationBlockMessageAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationBlockMessageAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    messageId: Snowflake.parse(json['target_id']),
    ruleTriggerType: json['options']?['rule_trigger_type'] ?? 'Unknown',
  );
}

Future<AuditLog> autoModerationFlagToChannelAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationFlagToChannelAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    messageId: Snowflake.parse(json['target_id']),
    channelId: json['options']?['channel_id'] != null
        ? Snowflake.parse(json['options']['channel_id'])
        : null,
  );
}

Future<AuditLog> autoModerationUserCommunicationDisabledAuditLogHandler(
    Map<String, dynamic> json) async {
  return AutoModerationUserCommunicationDisabledAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    moderatorId: Snowflake.parse(json['user_id']),
    userId: Snowflake.parse(json['target_id']),
    duration: json['options']?['duration'] ?? 0,
  );
}
