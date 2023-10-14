import 'package:mineral/api/common/emojis/emoji.dart';
import 'package:mineral/api/common/resources/activities/activity_type.dart';
import 'package:mineral/api/server/contracts/emoji_contracts.dart';

final class UserActivity {
  final String? state;
  final ActivityType? type;
  final EmojiContract? emoji;
  final String? createdAt;

  UserActivity._({
    required this.state,
    required this.type,
    required this.emoji,
    required this.createdAt,
  });

  factory UserActivity.fromWss(Map<String, dynamic> payload) =>
    UserActivity._(
      state: payload['state'],
      type: ActivityType.values[payload['type']],
      emoji: payload['emoji'] != null ? Emoji.fromWss(payload['emoji']) : null,
      createdAt: payload['created_at'].toString(),
    );
}