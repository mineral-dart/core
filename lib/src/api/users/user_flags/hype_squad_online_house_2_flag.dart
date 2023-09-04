import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an Brillance House squad member.
class HypeSquadBrillanceHouseMember extends UserFlagContract {
  HypeSquadBrillanceHouseMember(): super('House Brilliance Member', 1 << 7, 'ec8e92568a7c8f19a052ef42f862ff18.svg');
}