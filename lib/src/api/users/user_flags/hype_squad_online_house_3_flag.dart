import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an Balance House squad member.
class HypeSquadBalanceHouseMember extends UserFlagContract {
  HypeSquadBalanceHouseMember(): super('House Balance Member', 1 << 8, '9f00b18e292e10fc0ae84ff5332e8b0b.svg');
}