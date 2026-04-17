import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class WebhookCreateAuditLog extends AuditLog {
  final Snowflake webhookId;
  final String webhookName;
  final Snowflake? channelId;

  WebhookCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.webhookId,
    required this.webhookName,
    this.channelId,
  }) : super(AuditLogType.webhookCreate, serverId, userId);
}

final class WebhookUpdateAuditLog extends AuditLog {
  final Snowflake webhookId;
  final List<Change> changes;

  WebhookUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.webhookId,
    required this.changes,
  }) : super(AuditLogType.webhookUpdate, serverId, userId);
}

final class WebhookDeleteAuditLog extends AuditLog {
  final Snowflake webhookId;
  final String webhookName;
  final Snowflake? channelId;

  WebhookDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.webhookId,
    required this.webhookName,
    this.channelId,
  }) : super(AuditLogType.webhookDelete, serverId, userId);
}
