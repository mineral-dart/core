import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/snowflake.dart';

final class Role {
  final Snowflake id;
  final String name;
  final int color;
  final bool hoist;
  final int position;
  final bool managed;
  final bool mentionable;
  final int flags;
  final String? icon;
  final String? unicodeEmoji;
  final Map<String, dynamic> tags;
  final Permissions permissions;

  Role({
    required this.id,
    required this.name,
    required this.color,
    required this.hoist,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    required this.flags,
    required this.icon,
    required this.unicodeEmoji,
    required this.tags,
  });
}
