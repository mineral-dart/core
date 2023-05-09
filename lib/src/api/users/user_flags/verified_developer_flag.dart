import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an verified developer.
class VerifiedDeveloperFlag extends UserFlagContract {
  VerifiedDeveloperFlag(): super('Early Verified Bot Developer', 1 << 17, '4441e07fe0f46b3cb41b79366236fca6.svg');
}