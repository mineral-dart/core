import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/helper.dart';
import 'package:mineral/api/server/contracts/guild_member_contracts.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/api/server/resources/permission.dart';

final class GuildMember implements GuildMemberContract {
  @override
  Image? avatar;

  @override
  bool isDeaf;

  @override
  DateTime joinedAt;

  @override
  bool isMute;

  @override
  String? nick;

  @override
  bool? isPending;

  @override
  List<Permission>? permissions;

  @override
  DateTime? premiumSince;

  @override
  List<RoleContract> roles;

  @override
  User user;

  @override
  PresenceContracts? presence;

  GuildMember._({
    required this.avatar,
    required this.isDeaf,
    required this.joinedAt,
    required this.isMute,
    required this.nick,
    required this.isPending,
    required this.permissions,
    required this.premiumSince,
    required this.roles,
    required this.user,
  });

  factory GuildMember.fromWss(Map<String, dynamic> payload, Guild guild) =>
      GuildMember._(
        avatar: payload['avatar'] != null ? Image(label: payload['avatar']) : null,
        isDeaf: payload['deaf'],
        joinedAt: DateTime.parse(payload['joined_at']),
        isMute: payload['mute'],
        nick: payload['nick'],
        isPending: payload['pending'],
        permissions: payload['permissions'] != null ? Helper.bitfieldToPermissions(payload['permissions']) : null,
        premiumSince: payload['premium_since'] != null ? DateTime.parse(payload['premium_since']) : null,
        roles: (payload['roles'] as List<dynamic>).map((e) => guild.roles.cache.getOrFail(Snowflake(e))).toList(),
        user: User.fromWss(payload['user']),
    );
}