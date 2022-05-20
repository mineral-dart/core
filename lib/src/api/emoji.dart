part of api;

class Emoji {
  Snowflake id;
  String label;
  List<Role> roles;
  GuildMember? creator;
  bool requireColons;
  bool managed;
  bool animated;
  bool available;

  Emoji({
    required this.id,
    required this.label,
    required this.roles,
    required this.creator,
    required this.requireColons,
    required this.managed,
    required this.animated,
    required this.available,
  });

  factory Emoji.from({ required MemberManager memberManager, required RoleManager roleManager, required dynamic payload }) {
    List<Role> roles = [];
    for (dynamic id in payload['roles']) {
      Role? role = roleManager.cache.get(id);
      if (role != null) {
        roles.add(role);
      }
    }

    return Emoji(
      id: payload['id'],
      label: payload['name'],
      roles: roles,
      creator: payload['user'] != null ? memberManager.cache.get(payload['user']['id']) : null,
      requireColons: payload['require_colons'] ?? false,
      managed: payload['managed'] ?? false,
      animated: payload['animated'] ?? false,
      available: payload['available'] ?? false,
    );
  }
}
