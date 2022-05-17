import 'package:mineral/src/constants.dart';

class Role {
  Snowflake id;
  String label;
  int color;
  bool hoist;
  String? icon;
  String? unicodeEmoji;
  int position;
  int permissions;
  bool managed;
  bool mentionable;
  // @todo https://discord.com/developers/docs/topics/permissions#role-object-role-tags-structure

  Role({
    required this.id,
    required this.label,
    required this.color,
    required this.hoist,
    required this.icon,
    required this.unicodeEmoji,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
  });

  factory Role.from(dynamic payload) {
    return Role(
      id: payload['id'],
      label: payload['name'],
      color: payload['color'],
      hoist: payload['hoist'],
      icon: payload['icon'],
      unicodeEmoji: payload['unicode_emoji'],
      position: payload['position'],
      permissions: payload['permissions'],
      managed: payload['managed'],
      mentionable: payload['mentionable']
    );
  }
}
