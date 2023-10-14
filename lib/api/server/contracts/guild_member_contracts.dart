import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/enums.dart';

abstract interface class GuildMemberContract {
  abstract final User user;
  abstract final String? nick;
  abstract final Image? avatar;
  abstract final List<RoleContract> roles;
  abstract final DateTime joinedAt;
  abstract final DateTime? premiumSince;
  abstract final bool deaf;
  abstract final bool mute;
  abstract final bool? pending;
  abstract final List<Permission>? permissions;
  abstract PresenceContracts? presence;
}