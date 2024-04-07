import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/api/server/member_voice.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/parts/member_part.dart';

final class Member {
  MemberPart get _memberMethods => DataStore.singleton().member;

  late final MemberVoice voice;

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
  final bool mfAEnabled;
  final String? locale;
  final PremiumTier premiumType;
  final DateTime? joinedAt;
  final Permissions permissions;
  final bool pending;
  final int? accentColor;
  Presence? presence;

  bool canByPassVerification() => flags.contains(MemberFlag.bypassedVerification);

  bool hasCompletedOnboarding() => flags.contains(MemberFlag.completedOnboarding);

  bool hasStartedOnboarding() => flags.contains(MemberFlag.startedOnboarding);

  bool hasRejoined() => flags.contains(MemberFlag.didRejoin);

  Future<void> setNickname(String value, String? reason) => _memberMethods.updateMember(
      serverId: server.id, memberId: id, payload: {'nick': value}, reason: reason);

  Future<void> ban({Duration? deleteSince, String? reason}) =>
      _memberMethods.banMember(serverId: server.id, memberId: id, deleteSince: deleteSince);

  Future<void> kick({String? reason}) =>
      _memberMethods.kickMember(serverId: server.id, memberId: id, reason: reason);

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
    required this.mfAEnabled,
    required this.locale,
    required this.premiumType,
    required this.joinedAt,
    required this.permissions,
    required this.pending,
    required this.accentColor,
    required this.presence,
  }) {
    voice = MemberVoice(this);
  }
}
