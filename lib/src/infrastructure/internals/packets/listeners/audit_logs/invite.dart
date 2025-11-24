import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/invite.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> inviteCreateAuditLogHandler(Map<String, dynamic> json) async {
  return InviteCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    inviteCode: json['changes'][0]['new_value'],
    maxAge: json['options']?['max_age'] ?? 0,
    maxUses: json['options']?['max_uses'] ?? 0,
    isInviteTemporary: json['options']?['temporary'] ?? false,
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> inviteUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return InviteUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    inviteCode: json['target_id'],
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> inviteDeleteAuditLogHandler(Map<String, dynamic> json) async {
  final code = List.from(json['changes']).firstWhere(
    (change) => change['key'] == 'code',
  )['old_value'];

  return InviteDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    inviteCode: code ?? 'Unknown',
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}
