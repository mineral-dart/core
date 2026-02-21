import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/actions/member.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> memberKickAuditLogHandler(Map<String, dynamic> json) async {
  return MemberKickAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
    reason: json['reason'],
  );
}

Future<AuditLog> memberPruneAuditLogHandler(Map<String, dynamic> json) async {
  return MemberPruneAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    deleteMemberDays: json['options']?['delete_member_days'] ?? 0,
    membersRemoved: json['options']?['members_removed'] ?? 0,
  );
}

Future<AuditLog> memberBanAddAuditLogHandler(Map<String, dynamic> json) async {
  return MemberBanAddAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
    reason: json['reason'],
  );
}

Future<AuditLog> memberBanRemoveAuditLogHandler(
    Map<String, dynamic> json) async {
  return MemberBanRemoveAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
  );
}

Future<AuditLog> memberUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return MemberUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> memberRoleUpdateAuditLogHandler(
    Map<String, dynamic> json) async {
  return MemberRoleUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
  );
}

Future<AuditLog> memberMoveAuditLogHandler(Map<String, dynamic> json) async {
  return MemberMoveAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
    channelId: Snowflake.nullable(json['options']?['channel_id']),
  );
}

Future<AuditLog> memberDisconnectAuditLogHandler(
    Map<String, dynamic> json) async {
  return MemberDisconnectAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    memberId: Snowflake.nullable(json['target_id']),
  );
}

Future<AuditLog> botAddAuditLogHandler(Map<String, dynamic> json) async {
  return BotAddAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.nullable(json['user_id']),
    botId: Snowflake.nullable(json['target_id']),
  );
}
