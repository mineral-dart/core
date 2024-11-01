import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/common/premium_tier.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/builders/member_builder.dart';
import 'package:mineral/src/api/server/enums/member_flag.dart';
import 'package:mineral/src/api/server/managers/member_role_manager.dart';
import 'package:mineral/src/api/server/member_assets.dart';
import 'package:mineral/src/api/server/member_flags.dart';
import 'package:mineral/src/api/server/member_timeout.dart';
import 'package:mineral/src/api/server/member_voice.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/member_part.dart';

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

  /// Check if the member can bypass verification.
  ///
  /// ```dart
  /// if (member.canByPassVerification()) {
  ///  print('Member can bypass verification');
  /// }
  bool canByPassVerification() =>
      flags.list.contains(MemberFlag.bypassedVerification);

  /// Check if the member has completed onboarding.
  ///
  /// ```dart
  /// if (member.hasCompletedOnboarding()) {
  ///   print('Member has completed onboarding');
  /// }
  bool hasCompletedOnboarding() =>
      flags.list.contains(MemberFlag.completedOnboarding);

  /// Check if the member has started onboarding.
  ///
  /// ```dart
  /// if (member.hasStartedOnboarding()) {
  ///    print('Member has started onboarding');
  /// }
  bool hasStartedOnboarding() =>
      flags.list.contains(MemberFlag.startedOnboarding);

  /// Check if the member has already rejoined the server.
  ///
  /// ```dart
  /// if (member.hasRejoined()) {
  ///    print('Member has rejoined the server');
  /// }
  bool hasRejoined() => flags.list.contains(MemberFlag.didRejoin);

  /// Change the member's username.
  ///
  /// ```dart
  /// await member.setUsername('new-username', 'Testing');
  /// ```
  Future<void> setUsername(String value, String? reason) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: id,
          payload: {'username': value},
          reason: reason);

  /// Change the member's nickname.
  ///
  /// ```dart
  /// await member.setNickname('new-nickname', 'Testing');
  /// ```
  Future<void> setNickname(String value, String? reason) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: id,
          payload: {'nick': value},
          reason: reason);

  /// Ban the member.
  ///
  /// ```dart
  /// await member.ban(deleteSince: Duration(days: 7), reason: 'Testing');
  /// ```
  Future<void> ban({Duration? deleteSince, String? reason}) => _memberMethods
      .banMember(serverId: server.id, memberId: id, deleteSince: deleteSince);

  /// Kick the member.
  ///
  /// ```dart
  /// await member.kick(reason: 'Testing');
  /// ```
  Future<void> kick({String? reason}) => _memberMethods.kickMember(
      serverId: server.id, memberId: id, reason: reason);

  /// Exclude the member.
  ///
  /// ```dart
  /// await member.exclude(duration: Duration(days: 7), reason: 'Testing');
  /// ```
  Future<void> exclude({Duration? duration, String? reason}) {
    final timeout =
        duration != null ? DateTime.now().add(duration) : DateTime.now();

    return _memberMethods.updateMember(
        serverId: server.id,
        memberId: id,
        reason: reason,
        payload: {'communication_disabled_until': timeout.toIso8601String()});
  }

  /// Unexclude the member.
  ///
  /// ```dart
  /// await member.unExclude(reason: 'Testing');
  /// ```
  Future<void> unExclude({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      reason: reason,
      payload: {'communication_disabled_until': null});

  /// Enable the member's MFA. This member will be required to verify their account for accessing the server.
  ///
  /// ```dart
  /// await member.enableMfa(reason: 'Testing');
  /// ```
  Future<void> enableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      payload: {'mfa_enable': true},
      reason: reason);

  /// Disable the member's MFA.
  ///
  /// ```dart
  /// await member.disableMfa(reason: 'Testing');
  /// ```
  Future<void> disableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      payload: {'mfa_enable': false},
      reason: reason);

  /// Toggle the member's MFA.
  ///
  /// ```dart
  /// await member.toggleMfa(reason: 'Testing');
  /// ```
  Future<void> toggleMfa({String? reason}) =>
      mfaEnabled ? disableMfa(reason: reason) : enableMfa(reason: reason);

  /// Edit the member.
  ///
  /// ```dart
  /// await member.edit(MemberBuilder({
  ///   nickname: 'new-nickname',
  ///   isMuted: true,
  ///   ...
  /// }), reason: 'Testing');
  /// ```
  Future<void> edit(MemberBuilder builder, {String? reason}) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: id,
          reason: reason,
          payload: {
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
