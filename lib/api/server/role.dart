final class Role {
  final String id;
  final String name;
  final int color;
  final bool hoist;
  final int position;
  final int permissions;
  final bool managed;
  final bool mentionable;
  final int flags;

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
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      hoist: json['hoist'],
      position: json['position'],
      permissions: int.parse(json['permissions']),
      managed: bool.parse(json['managed']),
      mentionable: bool.parse(json['mentionable']),
      flags: int.parse(json['flags']),
    );
  }
}
