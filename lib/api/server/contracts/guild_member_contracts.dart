import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/resources/picture.dart';
import 'package:mineral/api/common/user/user.dart';
import 'package:mineral/api/server/contracts/role_contracts.dart';
import 'package:mineral/api/server/resources/enums.dart';

abstract interface class GuildMemberContract {
  abstract final User user;
  abstract final String? nick;
  abstract final Picture? avatar;
  abstract final List<RoleContract> roles;
  abstract final DateTime joinedAt;
  abstract final DateTime? premiumSince;
  abstract final bool isDeaf;
  abstract final bool isMute;
  abstract final bool? isPending;
  abstract final List<Permission>? permissions;
  abstract PresenceContracts? presence;
}