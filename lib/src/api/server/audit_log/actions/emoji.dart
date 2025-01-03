import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class EmojiCreateAuditLog extends AuditLog {
  final String emojiName;

  EmojiCreateAuditLog(
      {required Snowflake serverId, required Snowflake userId, required this.emojiName})
      : super(AuditLogType.emojiCreate, serverId, userId);

  factory EmojiCreateAuditLog.fromJson(Map<String, dynamic> json) {
    return EmojiCreateAuditLog(
        serverId: json['guild_id'],
        emojiName: json['changes'][0]['new_value'],
        userId: json['user_id']);
  }
}

final class EmojiUpdateAuditLog extends AuditLog {
  final String beforeEmojiName;
  final String afterEmojiName;

  EmojiUpdateAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.beforeEmojiName,
      required this.afterEmojiName})
      : super(AuditLogType.emojiCreate, serverId, userId);

  factory EmojiUpdateAuditLog.fromJson(Map<String, dynamic> json) {
    return EmojiUpdateAuditLog(
        serverId: json['guild_id'],
        beforeEmojiName: json['changes'][0]['old_value'],
        afterEmojiName: json['changes'][0]['new_value'],
        userId: json['user_id']);
  }
}

final class EmojiDeleteAuditLog extends AuditLog {
  final String emojiName;

  EmojiDeleteAuditLog(
      {required Snowflake serverId, required Snowflake userId, required this.emojiName})
      : super(AuditLogType.emojiDelete, serverId, userId);

  factory EmojiDeleteAuditLog.fromJson(Map<String, dynamic> json) {
    return EmojiDeleteAuditLog(
        serverId: json['guild_id'],
        emojiName: json['changes'][0]['old_value'],
        userId: json['user_id']);
  }
}
