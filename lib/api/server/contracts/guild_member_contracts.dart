import 'package:mineral/api/common/resources/image.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/enums.dart';

abstract interface class GuildMemberContract {
  abstract final User user;
  abstract String? nick;
  abstract Image? avatar;
  abstract List<RoleContract> roles;
  abstract DateTime joinedAt;
  abstract DateTime? premiumSince;
  abstract bool deaf;
  abstract bool mute;
  abstract bool? pending;
  abstract List<Permission>? permissions;
}