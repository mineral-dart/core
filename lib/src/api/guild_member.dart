part of api;

class GuildMember {
  User user;
  String? nickname;
  String? avatar;
  DateTime joinedAt;
  DateTime? premiumSince;
  String? permissions;
  bool isPending;
  DateTime? timeoutDuration;
  RoleManager roles;
  Voice voice;
  late Guild guild;

  GuildMember({
    required this.user,
    required this.nickname,
    required this.avatar,
    required this.joinedAt,
    required this.premiumSince,
    required this.permissions,
    required this.isPending,
    required this.timeoutDuration,
    required this.roles,
    required this.voice,
  });

  Future<void> setUsername (String name) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${guild.id}/members/${user.id}", payload: { 'nick': name });
    if (response.statusCode == 200) {
      nickname = name;
    }
  }

  Future<void> timeout (DateTime expiration) async {
    // @Todo add ADMINISTRATOR permission or is the owner of the guild constraint
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${guild.id}/members/${user.id}", payload: { 'deaf': expiration.toIso8601String() });
    if (response.statusCode == 200) {
      timeoutDuration = expiration;
    }
  }

  Future<void> removeTimeout () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${guild.id}/members/${user.id}", payload: { 'deaf': null });
    if (response.statusCode == 200) {
      timeoutDuration = null;
    }
  }

  Future<void> ban ({ int? count, String? reason }) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.patch(url: "/guilds/${guild.id}/bans/${user.id}", payload: {
      'delete_message_days': count,
      'reason': reason
    });

    if (response.statusCode == 200) {
      timeoutDuration = null;
    }
  }

  Future<void> kick ({ int? count, String? reason }) async {
    Http http = ioc.singleton(Service.http);
    await http.destroy(url: "/guilds/${guild.id}/members/${user.id}");
  }

  @override
  String toString () {
    return "<@${nickname != null ? '!' : ''}${user.id}>";
  }

  factory GuildMember.from({ required user, required RoleManager roles, dynamic member, required Snowflake guildId }) {
    RoleManager roleManager = RoleManager(guildId: guildId);
    for (var element in (member['roles'] as List<dynamic>)) {
      Role? role = roles.cache.get(element);
      if (role != null) {
        roleManager.cache.putIfAbsent(role.id, () => role);
      }
    }

    return GuildMember(
      user: user,
      nickname: member['nick'],
      avatar: member['avatar'],
      joinedAt: DateTime.parse(member['joined_at']),
      premiumSince: member['premium_since'] != null ? DateTime.parse(member['premium_since']) : null,
      permissions: member['permissions'],
      isPending: member['pending'] == true,
      timeoutDuration: member['communication_disabled_until'] != null ? DateTime.parse(member['communication_disabled_until']) : null,
      roles: roleManager,
      voice: Voice.from(payload: member),
    );
  }
}
