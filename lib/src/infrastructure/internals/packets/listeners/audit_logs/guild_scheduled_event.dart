import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/guild_scheduled_event.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> guildScheduledEventCreateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return GuildScheduledEventCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    eventId: Snowflake.parse(json['target_id']),
  );
}

Future<AuditLog> guildScheduledEventUpdateAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return GuildScheduledEventUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    eventId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> guildScheduledEventDeleteAuditLogHandler(
  Map<String, dynamic> json,
) async {
  return GuildScheduledEventDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    eventId: Snowflake.parse(json['target_id']),
  );
}
