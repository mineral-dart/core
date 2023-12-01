final class Role {
  final String id;
  final String name;
  final int color;
  final bool hoist;
  final int position;
  final int permissions;
  final bool managed;
  final bool mentionable;
  final String guildId;

  Role({
    required this.id,
    required this.name,
    required this.color,
    required this.hoist,
    required this.position,
    required this.permissions,
    required this.managed,
    required this.mentionable,
    required this.guildId,
  });
}
