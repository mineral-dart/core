import 'package:mineral/core/api.dart';

class TeamPseudoUserFlag extends UserFlagContract {
  TeamPseudoUserFlag(): super('User is a team', 1 << 10, '');
}