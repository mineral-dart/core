import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class StageInstanceCreateAuditLog extends AuditLog {
  final Snowflake stageInstanceId;
  final String topic;
  final Snowflake? channelId;

  StageInstanceCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.stageInstanceId,
    required this.topic,
    this.channelId,
  }) : super(AuditLogType.stageInstanceCreate, serverId, userId);
}

final class StageInstanceUpdateAuditLog extends AuditLog {
  final Snowflake stageInstanceId;
  final List<Change> changes;

  StageInstanceUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.stageInstanceId,
    required this.changes,
  }) : super(AuditLogType.stageInstanceUpdate, serverId, userId);
}

final class StageInstanceDeleteAuditLog extends AuditLog {
  final Snowflake stageInstanceId;
  final String topic;
  final Snowflake? channelId;

  StageInstanceDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.stageInstanceId,
    required this.topic,
    this.channelId,
  }) : super(AuditLogType.stageInstanceDelete, serverId, userId);
}
