import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an Early Nitro Supporter.
class PremiumEarlySupporterFlag extends UserFlagContract {
  PremiumEarlySupporterFlag(): super('Early Nitro Supporter', 1 << 9, 'b802e9af134ff492276d94220e36ec5c.svg');
}