/// [AuditLog] repository
///
/// Related to the official [Discord API documentation](https://discord.com/developers/docs/resources/audit-log)
final class AuditLogRepository {
  /// Get audit log
  /// Related [official documentation](https://discord.com/developers/docs/resources/audit-log#get-guild-audit-log)
  /// ```dart
  /// final uri = http.endpoints.auditLogs.get('1234');
  /// ```
  String get({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'audit-logs']).path;
}