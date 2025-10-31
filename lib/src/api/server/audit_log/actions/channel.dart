import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class ChannelCreateAuditLogAction extends AuditLog {
  final Channel channel;

  ChannelCreateAuditLogAction({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channel,
  }) : super(AuditLogType.channelCreate, serverId, userId);
}

final class ChannelUpdateAuditLogAction extends AuditLog {
  final Channel channel;
  final List<Change> changes;

  ChannelUpdateAuditLogAction({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channel,
    required this.changes,
  }) : super(AuditLogType.channelCreate, serverId, userId);
}

final class ChannelDeleteAuditLogAction extends AuditLog {
  final Snowflake channelId;
  final List<Change> changes;

  ChannelDeleteAuditLogAction({
    required Snowflake serverId,
    required Snowflake userId,
    required this.channelId,
    required this.changes,
  }) : super(AuditLogType.channelCreate, serverId, userId);
}
