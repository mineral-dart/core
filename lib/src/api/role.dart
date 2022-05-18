part of api;

class Tag {
  Snowflake? botId;
  Snowflake? integrationId;
  bool? premiumSubscriber;

  Tag({ required this.botId, required Snowflake? integrationId, required bool? premiumSubscriber });

  factory Tag.from({ required payload }) {
    return Tag(
      botId: payload['bot_id'],
      integrationId: payload['integration_id'],
      premiumSubscriber: payload['premium_subscriber']
    );
  }
}

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
  Tag? tags;

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
    required this.tags
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
      mentionable: payload['mentionable'],
      tags: payload['tags'] != null ? Tag.from(payload: payload['tags']) : null
    );
  }
}
