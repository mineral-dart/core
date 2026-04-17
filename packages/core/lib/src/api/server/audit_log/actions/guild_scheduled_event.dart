import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class GuildScheduledEventCreateAuditLog extends AuditLog {
  final Snowflake eventId;

  GuildScheduledEventCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.eventId,
  }) : super(AuditLogType.guildScheduledEventCreate, serverId, userId);
}

final class GuildScheduledEventUpdateAuditLog extends AuditLog {
  final Snowflake eventId;
  final List<Change> changes;

  GuildScheduledEventUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.eventId,
    required this.changes,
  }) : super(AuditLogType.guildScheduledEventUpdate, serverId, userId);
}

final class GuildScheduledEventDeleteAuditLog extends AuditLog {
  final Snowflake eventId;

  GuildScheduledEventDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.eventId,
  }) : super(AuditLogType.guildScheduledEventDelete, serverId, userId);
}
