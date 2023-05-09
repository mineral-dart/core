import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is a team.
class TeamPseudoUserFlag extends UserFlagContract {
  TeamPseudoUserFlag(): super('User is a team', 1 << 10, '');
}