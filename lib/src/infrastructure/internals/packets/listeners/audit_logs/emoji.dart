import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> emojiCreateAuditLogHandler(Map<String, dynamic> json) async {
  return EmojiCreateAuditLog(
      serverId: json['guild_id'],
      emojiName: json['changes'][0]['new_value'],
      userId: json['user_id']);
}

Future<AuditLog> emojiUpdateAuditLogHandler(Map<String, dynamic> json) async {
  return EmojiUpdateAuditLog(
      serverId: json['guild_id'],
      beforeEmojiName: json['changes'][0]['old_value'],
      afterEmojiName: json['changes'][0]['new_value'],
      userId: json['user_id']);
}

Future<AuditLog> emojiDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return EmojiDeleteAuditLog(
      serverId: json['guild_id'],
      emojiName: json['changes'][0]['old_value'],
      userId: json['user_id']);
}
