import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class IntegrationCreateAuditLog extends AuditLog {
  final Snowflake integrationId;
  final String integrationType;

  IntegrationCreateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.integrationId,
    required this.integrationType,
  }) : super(AuditLogType.integrationCreate, serverId, userId);
}

final class IntegrationUpdateAuditLog extends AuditLog {
  final Snowflake integrationId;
  final List<Change> changes;

  IntegrationUpdateAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.integrationId,
    required this.changes,
  }) : super(AuditLogType.integrationUpdate, serverId, userId);
}

final class IntegrationDeleteAuditLog extends AuditLog {
  final Snowflake integrationId;
  final String integrationType;

  IntegrationDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.integrationId,
    required this.integrationType,
  }) : super(AuditLogType.integrationDelete, serverId, userId);
}
