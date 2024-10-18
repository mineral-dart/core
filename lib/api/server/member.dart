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
  final bool pending;
  final int? accentColor;
  final MemberFlagsManager flags;
  Presence? presence;

  bool canByPassVerification() =>
      flags.list.contains(MemberFlag.bypassedVerification);

  bool hasCompletedOnboarding() =>
      flags.list.contains(MemberFlag.completedOnboarding);

  bool hasStartedOnboarding() =>
      flags.list.contains(MemberFlag.startedOnboarding);

  bool hasRejoined() => flags.list.contains(MemberFlag.didRejoin);

  /// Sets the member's username.
  ///
  /// - `value`: The new username for the member.
  /// - `reason`: (Optional) The reason for the username change.
  ///
  /// Example:
  /// ```dart
  /// member.setUsername("NewUsername");
  /// ```
  Future<void> setUsername(String value, String? reason) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: id,
          payload: {'username': value},
          reason: reason);

  /// Sets the member's nickname.
  ///
  /// - `value`: The new nickname for the member.
  /// - `reason`: (Optional) The reason for the nickname change.
  ///
  /// Example:
  /// ```dart
  /// member.setNickname("NewNickname");
  /// ```
  Future<void> setNickname(String value, String? reason) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: id,
          payload: {'nick': value},
          reason: reason);

  /// Bans the member from the server.
  ///
  /// - `deleteSince`: (Optional) The duration of messages to be deleted after the ban.
  /// - `reason`: (Optional) The reason for the ban.
  ///
  /// Example:
  /// ```dart
  /// member.ban(deleteSince: Duration(days: 7), reason: "Violation of rules");
  /// ```
  Future<void> ban({Duration? deleteSince, String? reason}) => _memberMethods
      .banMember(serverId: server.id, memberId: id, deleteSince: deleteSince);

  /// Kicks the member from the server.
  ///
  /// - `reason`: (Optional) The reason for the kick.
  ///
  /// Example:
  /// ```dart
  /// member.kick(reason: "Disruptive behavior");
  /// ```
  Future<void> kick({String? reason}) => _memberMethods.kickMember(
      serverId: server.id, memberId: id, reason: reason);

  /// Temporarily excludes the member from communication in the server.
  ///
  /// - `duration`: The duration of the exclusion.
  /// - `reason`: (Optional) The reason for the exclusion.
  ///
  /// Example:
  /// ```dart
  /// member.exclude(duration: Duration(hours: 1), reason: "Inappropriate behavior");
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

  /// Stops the member's exclusiion.
  ///
  /// - `reason`: (Optional) The reason for stopping the exclusion.
  ///
  /// Example:
  /// ```dart
  /// member.unExclude(reason: "Timeout period ended");
  /// ```
  Future<void> unExclude({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      reason: reason,
      payload: {'communication_disabled_until': null});

  /// Enables multi-factor authentication (MFA) for the member.
  ///
  /// - `reason`: (Optional) The reason for enabling MFA.
  ///
  /// Example:
  /// ```dart
  /// member.enableMfa(reason: "Security upgrade");
  /// ```
  Future<void> enableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      payload: {'mfa_enable': true},
      reason: reason);

  /// Disables multi-factor authentication (MFA) for the member.
  ///
  /// - `reason`: (Optional) The reason for disabling MFA.
  ///
  /// Example:
  /// ```dart
  /// member.disableMfa(reason: "No longer needed");
  /// ```
  Future<void> disableMfa({String? reason}) => _memberMethods.updateMember(
      serverId: server.id,
      memberId: id,
      payload: {'mfa_enable': false},
      reason: reason);

  /// Toggles the member's multi-factor authentication (MFA) status.
  ///
  /// - `reason`: (Optional) The reason for toggling MFA.
  ///
  /// Example:
  /// ```dart
  /// member.toggleMfa(reason: "Because that's the way it is.");
  /// ```
  Future<void> toggleMfa({String? reason}) =>
      mfaEnabled ? disableMfa(reason: reason) : enableMfa(reason: reason);
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
    required this.pending,
    required this.accentColor,
    required this.presence,
  }) {
    voice = MemberVoice(this);
  }
}
