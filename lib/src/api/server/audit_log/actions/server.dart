import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class ServerUpdateAuditLogAction extends AuditLog {
  final List<Change> changes;

  ServerUpdateAuditLogAction(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.changes})
      : super(AuditLogType.guildUpdate, serverId, userId);

  factory ServerUpdateAuditLogAction.fromJson(Map<String, dynamic> json) {
    return ServerUpdateAuditLogAction(
        serverId: Snowflake.parse(json['guild_id']),
        userId: Snowflake.parse(json['user_id']),
        changes:
            List<Change>.from(json['changes'].map((e) => Change.fromJson(e))));
  }
}
