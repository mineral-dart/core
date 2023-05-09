import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an Bravery House squad member.
class HypeSquadBraveryHouseMember extends UserFlagContract {
  HypeSquadBraveryHouseMember(): super('House Bravery Member', 1 << 6, '34306011e46e87f8ef25f3415d3b99ca.svg');
}