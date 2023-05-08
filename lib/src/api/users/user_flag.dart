import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/users/user_flags/active_developer_flag.dart';
import 'package:mineral/src/api/users/user_flags/bot_http_interactions_flag.dart';
import 'package:mineral/src/api/users/user_flags/bug_hunter_level_1_flag.dart';
import 'package:mineral/src/api/users/user_flags/bug_hunter_level_2_flag.dart';
import 'package:mineral/src/api/users/user_flags/certified_moderator_flag.dart';
import 'package:mineral/src/api/users/user_flags/hype_squad_flag.dart';
import 'package:mineral/src/api/users/user_flags/hype_squad_online_house_1_flag.dart';
import 'package:mineral/src/api/users/user_flags/hype_squad_online_house_2_flag.dart';
import 'package:mineral/src/api/users/user_flags/hype_squad_online_house_3_flag.dart';
import 'package:mineral/src/api/users/user_flags/partner_flag.dart';
import 'package:mineral/src/api/users/user_flags/premium_early_supporter_flag.dart';
import 'package:mineral/src/api/users/user_flags/staff_flag.dart';
import 'package:mineral/src/api/users/user_flags/team_pseudo_user_flag.dart';
import 'package:mineral/src/api/users/user_flags/verified_bot_flag.dart';
import 'package:mineral/src/api/users/user_flags/verified_developer_flag.dart';

class UserFlag {
  /// The user is a Discord employee.
  static get staff => StaffFlag();

  /// The user is a partner.
  static get partner => PartnerFlag();

  /// The user is a HypeSquad member.
  static get hypeSquad => HypeSquadFlag();

  /// The user is a Bug Hunter.
  static get bugHunterLevel1 => BugHunterLevel1Flag();

  /// The user is a HypeSquad member from House Bravery Squad.
  static get hypeSquadOnlineHouse1 => HypeSquadOnlineHouse1Flag();

  /// The user is a HypeSquad member from House Brilliance Squad.
  static get hypeSquadOnlineHouse2 => HypeSquadOnlineHouse2Flag();

  /// The user is a HypeSquad member from House Balance Squad.
  static get hypeSquadOnlineHouse3 => HypeSquadOnlineHouse3Flag();

  /// The user has purchased Nitro before it was renamed to Nitro Classic.
  static get premiumEarlySupporter => PremiumEarlySupporterFlag();

  /// The user is a member of a team.
  static get teamPseudoUser => TeamPseudoUserFlag();

  /// The user is a Bug Hunter level 2.
  static get bugHunterLevel2 => BugHunterLevel2Flag();

  /// The user is a verified bot.
  static get verifiedBot => VerifiedBotFlag();

  /// The user is a verified developer.
  static get verifiedDeveloper => VerifiedDeveloperFlag();

  /// The user is a certified moderator.
  static get certifiedModerator => CertifiedModeratorFlag();

  /// The user is a bot can use HTTP interactions.
  static get botHttpInteractions => BotHttpInteractionsFlag();

  /// The user is an active developer.
  static get activeDeveloper => ActiveDeveloperFlag();

  static final List<UserFlagContract> _flags = [
    UserFlag.staff,
    UserFlag.partner,
    UserFlag.hypeSquad,
    UserFlag.bugHunterLevel1,
    UserFlag.hypeSquadOnlineHouse1,
    UserFlag.hypeSquadOnlineHouse2,
    UserFlag.hypeSquadOnlineHouse3,
    UserFlag.premiumEarlySupporter,
    UserFlag.teamPseudoUser,
    UserFlag.bugHunterLevel2,
    UserFlag.verifiedBot,
    UserFlag.verifiedDeveloper,
    UserFlag.certifiedModerator,
    UserFlag.botHttpInteractions,
    UserFlag.activeDeveloper,
  ];

  /// Finds a flag by its value.
  static UserFlagContract find (int value) => _flags.firstWhere((element) => element.value == value);

  /// Get all flags.
  static get values => _flags.map((e) => e.value);

  UserFlag._();
}