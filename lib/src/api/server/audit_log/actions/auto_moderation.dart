import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class AutoModerationRuleCreateAuditLog extends AuditLog {
  final Snowflake ruleId;

  AutoModerationRuleCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.ruleId,
  }) : super(AuditLogType.autoModerationRuleCreate, serverId, userId);
}

final class AutoModerationRuleUpdateAuditLog extends AuditLog {
  final Snowflake ruleId;
  final List<Change> changes;

  AutoModerationRuleUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.ruleId,
    required this.changes,
  }) : super(AuditLogType.autoModerationRuleUpdate, serverId, userId);
}

final class AutoModerationRuleDeleteAuditLog extends AuditLog {
  final Snowflake ruleId;

  AutoModerationRuleDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.ruleId,
  }) : super(AuditLogType.autoModerationRuleDelete, serverId, userId);
}

final class AutoModerationBlockMessageAuditLog extends AuditLog {
  final Snowflake messageId;
  final String ruleTriggerType;

  AutoModerationBlockMessageAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.messageId,
    required this.ruleTriggerType,
  }) : super(AuditLogType.autoModerationBlockMessage, serverId, userId);
}

final class AutoModerationFlagToChannelAuditLog extends AuditLog {
  final Snowflake messageId;
  final Snowflake? channelId;

  AutoModerationFlagToChannelAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.messageId,
    this.channelId,
  }) : super(AuditLogType.autoModerationFlagToChannel, serverId, userId);
}

final class AutoModerationUserCommunicationDisabledAuditLog extends AuditLog {
  final int duration;

  AutoModerationUserCommunicationDisabledAuditLog({
    required Snowflake serverId,
    required Snowflake moderatorId,
    required this.duration,
    required Snowflake userId,
  }) : super(AuditLogType.autoModerationUserCommunicationDisabled, serverId,
            moderatorId);
}
