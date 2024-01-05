import 'package:mineral/api/common/avatar_decoration.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/shared/utils.dart';

final class Member {
  final String id;
  final String username;
  final String? nickname;
  final String? globalName;
  final String discriminator;
  final String? avatar;
  final AvatarDecoration? avatarDecoration;
  final int? flags;
  final DateTime? premiumSince;
  final int? publicFlags;
  late final Server server;
  final RoleManager roles;
  final bool isBot;

  Member._({
    required this.id,
    required this.username,
    required this.nickname,
    required this.globalName,
    required this.discriminator,
    required this.avatar,
    required this.avatarDecoration,
    required this.flags,
    required this.premiumSince,
    required this.publicFlags,
    required this.roles,
    required this.isBot,
  });

  factory Member.fromJson({required RoleManager roles, required Map<String, dynamic> member}) {
    return Member._(
      id: member['user']['id'],
      username: member['user']['nick'] ?? member['user']['username'],
      nickname: member['nick'] ?? member['user']['display_name'],
      globalName: member['user']['global_name'],
      discriminator: member['user']['discriminator'],
      avatar: member['avatar'],
      avatarDecoration: createOrNull(
          field: member['user']?['avatar_decoration_data'],
          fn: () => AvatarDecoration.fromJson(member['user']['avatar_decoration_data'])),
      flags: member['flags'],
      premiumSince: createOrNull(
          field: member['premium_since'], fn: () => DateTime.parse(member['premium_since'])),
      publicFlags: member['user']['public_flags'],
      roles: RoleManager.fromJson(roles.list, List<String>.from(member['roles'])),
      isBot: member['user']['bot'],
    );
  }
}
