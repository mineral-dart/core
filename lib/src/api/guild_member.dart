import 'package:mineral/src/api/guild.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/api/role.dart';
import 'package:mineral/src/api/user.dart';

class GuildMember {
  User user;
  String? nickname;
  String? avatar;
  DateTime joinedAt;
  DateTime? premiumSince;
  String? permissions;
  bool deaf;
  bool mute;
  bool pending;
  DateTime? timeout;
  RoleManager roles;
  late Guild guild;

  GuildMember({
    required this.user,
    required this.nickname,
    required this.avatar,
    required this.joinedAt,
    required this.premiumSince,
    required this.permissions,
    required this.deaf,
    required this.mute,
    required this.pending,
    required this.timeout,
    required this.roles,
  });

  factory GuildMember.from({ required user, required RoleManager roles, dynamic member }) {
    RoleManager roleManager = RoleManager();
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
      deaf: member['deaf'] == true,
      mute: member['mute'] == true,
      pending: member['pending'] == true,
      timeout: member['communication_disabled_until'] != null ? DateTime.parse(member['communication_disabled_until']) : null,
      roles: roleManager,
    );
  }
}
