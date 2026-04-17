import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class ServerUpdateAuditLogAction extends AuditLog {
  final Server server;
  final List<Change> changes;

  ServerUpdateAuditLogAction(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.server,
      required this.changes})
      : super(AuditLogType.guildUpdate, serverId, userId);
}
