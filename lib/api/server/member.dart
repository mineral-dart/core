import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/api/server/server.dart';

final class Member {
  final Snowflake id;
  final String username;
  final String? nickname;
  final String? globalName;
  final String discriminator;
  final MemberAssets assets;
  final List<MemberFlag> flags;
  final DateTime? premiumSince;
  final int? publicFlags;
  late final Server server;
  final RoleManager roles;
  final bool isBot;
  final bool isPending;
  final MemberTimeout timeout;

  bool canByPassVerification() => flags.contains(MemberFlag.bypassedVerification);

  bool hasCompletedOnboarding() => flags.contains(MemberFlag.completedOnboarding);

  bool hasStartedOnboarding() => flags.contains(MemberFlag.startedOnboarding);

  bool hasRejoined() => flags.contains(MemberFlag.didRejoin);

  Member({
    required this.id,
    required this.username,
    required this.nickname,
    required this.globalName,
    required this.discriminator,
    required this.assets,
    required this.flags,
    required this.premiumSince,
    required this.publicFlags,
    required this.roles,
    required this.isBot,
    required this.isPending,
    required this.timeout,
  });
}
