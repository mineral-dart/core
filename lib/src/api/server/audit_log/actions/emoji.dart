import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class EmojiCreateAuditLog extends AuditLog {
  final String emojiName;

  EmojiCreateAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.emojiName})
      : super(AuditLogType.emojiCreate, serverId, userId);
}

final class EmojiUpdateAuditLog extends AuditLog {
  final String beforeEmojiName;
  final String afterEmojiName;

  EmojiUpdateAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.beforeEmojiName,
      required this.afterEmojiName})
      : super(AuditLogType.emojiUpdate, serverId, userId);
}

final class EmojiDeleteAuditLog extends AuditLog {
  final String emojiName;

  EmojiDeleteAuditLog(
      {required Snowflake serverId,
      required Snowflake userId,
      required this.emojiName})
      : super(AuditLogType.emojiDelete, serverId, userId);
}
