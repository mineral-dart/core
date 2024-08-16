import 'package:mineral/api/common/permissions.dart';
import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/builders/member_builder.dart';
import 'package:mineral/api/server/enums/member_flag.dart';
import 'package:mineral/api/server/managers/member_role_manager.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/member_flags.dart';
import 'package:mineral/api/server/member_timeout.dart';
import 'package:mineral/api/server/member_voice.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/member_part.dart';

final class Member {
  MemberPart get _memberMethods => ioc.resolve<DataStoreContract>().member;

  late final MemberVoice voice;

  final Snowflake id;
  final String username;
  final String? nickname;
  final String? globalName;
  final String discriminator;
  final MemberAssets assets;
  final DateTime? premiumSince;
  final int? publicFlags;
  late final Server server;
  final MemberRoleManager roles;
  final bool isBot;
  final bool isPending;
  final MemberTimeout timeout;
  final bool mfaEnabled;
  final String? locale;
  final PremiumTier premiumType;
  final DateTime? joinedAt;
  final Permissions permissions;
  final int? accentColor;
  final MemberFlagsManager flags;
  Presence? presence;

  bool canByPassVerification() => flags.list.contains(MemberFlag.bypassedVerification);

  bool hasCompletedOnboarding() => flags.list.contains(MemberFlag.completedOnboarding);

  bool hasStartedOnboarding() => flags.list.contains(MemberFlag.startedOnboarding);

  bool hasRejoined() => flags.list.contains(MemberFlag.didRejoin);

  Future<void> setUsername(String value, String? reason) => _memberMethods.updateMember(
      serverId: server.id, memberId: id, payload: {'username': value}, reason: reason);

  Future<void> setNickname(String value, String? reason) => _memberMethods.updateMember(
      serverId: server.id, memberId: id, payload: {'nick': value}, reason: reason);

  Future<void> ban({Duration? deleteSince, String? reason}) =>
      _memberMethods.banMember(serverId: server.id, memberId: id, deleteSince: deleteSince);

  Future<void> kick({String? reason}) =>
      _memberMethods.kickMember(serverId: server.id, memberId: id, reason: reason);

  Future<void> exclude({Duration? duration, String? reason}) {
    final timeout = duration != null ? DateTime.now().add(duration) : DateTime.now();

    return _memberMethods.updateMember(
        serverId: server.id,
        memberId: id,
        reason: reason,
        payload: {'communication_disabled_until': timeout.toIso8601String()});
  }

  Future<void> unExclude({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      reason: reason,
      payload: {'communication_disabled_until': null});

  Future<void> enableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id, memberId: id, payload: {'mfa_enable': true}, reason: reason);

  Future<void> disableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id, memberId: id, payload: {'mfa_enable': false}, reason: reason);

  Future<void> toggleMfa({String? reason}) =>
      mfaEnabled ? disableMfa(reason: reason) : enableMfa(reason: reason);

  Future<void> edit(MemberBuilder builder, {String? reason}) =>
      _memberMethods.updateMember(serverId: server.id, memberId: id, reason: reason, payload: {
        'nick': nickname,
        'mute': builder.isMuted,
        'deaf': builder.isDeafened,
        'exclude': builder.isExcluded,
      });

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
    required this.mfaEnabled,
    required this.locale,
    required this.premiumType,
    required this.joinedAt,
    required this.permissions,
    required this.accentColor,
    required this.presence,
  }) {
    voice = MemberVoice(this);
  }
}
