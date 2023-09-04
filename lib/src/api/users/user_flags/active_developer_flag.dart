import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an active developer.
class ActiveDeveloperFlag extends UserFlagContract {
  ActiveDeveloperFlag(): super('User is an active developer', 1 << 22, '26c7a60fb1654315e0be26107bd47470.svg');
}