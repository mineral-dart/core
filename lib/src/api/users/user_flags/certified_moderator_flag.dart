import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an active developer.
class CertifiedModeratorFlag extends UserFlagContract {
  CertifiedModeratorFlag(): super('Moderator Programs Alumni', 1 << 18, 'b945002f0e0fd7f11990d800e98b5504.svg');
}