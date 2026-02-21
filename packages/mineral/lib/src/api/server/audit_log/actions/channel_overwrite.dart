import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class ChannelOverwriteCreateAuditLog extends AuditLog {
  final Snowflake channelId;
  final Snowflake overwriteId;
  final String overwriteType;
  final List<Change> changes;

  ChannelOverwriteCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channelId,
    required this.overwriteId,
    required this.overwriteType,
    required this.changes,
  }) : super(AuditLogType.channelOverwriteCreate, serverId, userId);
}

final class ChannelOverwriteUpdateAuditLog extends AuditLog {
  final Snowflake channelId;
  final Snowflake overwriteId;
  final String overwriteType;
  final List<Change> changes;

  ChannelOverwriteUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channelId,
    required this.overwriteId,
    required this.overwriteType,
    required this.changes,
  }) : super(AuditLogType.channelOverwriteUpdate, serverId, userId);
}

final class ChannelOverwriteDeleteAuditLog extends AuditLog {
  final Snowflake channelId;
  final Snowflake overwriteId;
  final String overwriteType;

  ChannelOverwriteDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channelId,
    required this.overwriteId,
    required this.overwriteType,
  }) : super(AuditLogType.channelOverwriteDelete, serverId, userId);
}
