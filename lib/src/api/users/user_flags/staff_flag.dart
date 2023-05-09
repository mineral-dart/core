import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an active developer.
class StaffFlag extends UserFlagContract {
  StaffFlag(): super('Discord Employee', 1 << 0, '48d5bdcffe9e7848067c2e187f1ef951.svg');
}