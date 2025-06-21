import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class ThreadCreateAuditLog extends AuditLog {
  final Snowflake threadId;
  final String threadName;
  final Snowflake? channelId;

  ThreadCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.threadId,
    required this.threadName,
    this.channelId,
  }) : super(AuditLogType.threadCreate, serverId, userId);
}

final class ThreadUpdateAuditLog extends AuditLog {
  final Snowflake threadId;
  final List<Change> changes;

  ThreadUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.threadId,
    required this.changes,
  }) : super(AuditLogType.threadUpdate, serverId, userId);
}

final class ThreadDeleteAuditLog extends AuditLog {
  final Snowflake threadId;
  final String threadName;
  final Snowflake? channelId;

  ThreadDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.threadId,
    required this.threadName,
    this.channelId,
  }) : super(AuditLogType.threadDelete, serverId, userId);
}
