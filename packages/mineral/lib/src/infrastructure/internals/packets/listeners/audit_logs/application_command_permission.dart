import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/application_command_permission.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> applicationCommandPermissionUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return ApplicationCommandPermissionUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    applicationId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}
