import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/api/server/audit_log/audit_log_action.dart';

Future<AuditLog> unknownAuditLogHandler(Map<String, dynamic> json) async {
  return UnknownAuditLogAction(
      serverId: Snowflake.parse(json['guild_id']),
      userId: Snowflake.nullable(json['user_id']));
}
