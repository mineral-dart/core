import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/api/server/member_voice.dart';
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
  final MemberVoice voice;
  final bool mfAEnabled;
  final String? locale;
  final PremiumTier premiumType;
  final DateTime? joinedAt;
  final Permissions permissions;
  final bool pending;
  final int? accentColor;

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
    required this.voice,
    required this.mfAEnabled,
    required this.locale,
    required this.premiumType,
    required this.joinedAt,
    required this.permissions,
    required this.pending,
    required this.accentColor,
  });
}
