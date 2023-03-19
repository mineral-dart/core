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
  static get staff => StaffFlag();
  static get partner => PartnerFlag();
  static get hypeSquad => HypeSquadFlag();
  static get bugHunterLevel1 => BugHunterLevel1Flag();
  static get hypeSquadOnlineHouse1 => HypeSquadOnlineHouse1Flag();
  static get hypeSquadOnlineHouse2 => HypeSquadOnlineHouse2Flag();
  static get hypeSquadOnlineHouse3 => HypeSquadOnlineHouse3Flag();
  static get premiumEarlySupporter => PremiumEarlySupporterFlag();
  static get teamPseudoUser => TeamPseudoUserFlag();
  static get bugHunterLevel2 => BugHunterLevel2Flag();
  static get verifiedBot => VerifiedBotFlag();
  static get verifiedDeveloper => VerifiedDeveloperFlag();
  static get certifiedModerator => CertifiedModeratorFlag();
  static get botHttpInteractions => BotHttpInteractionsFlag();
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

  static UserFlagContract find (int value) => _flags.firstWhere((element) => element.value == value);

  static get values => _flags.map((e) => e.value);
  UserFlag._();
}