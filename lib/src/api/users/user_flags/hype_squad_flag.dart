import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an hype squad events member.
class HypeSquadFlag extends UserFlagContract {
  HypeSquadFlag(): super('HypeSquad Events Member', 1 << 2, 'e666a84a7a5ea2abbbfa73adf22e627b.svg');
}