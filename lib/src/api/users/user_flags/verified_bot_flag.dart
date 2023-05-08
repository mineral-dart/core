import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is a verified bot.
class VerifiedBotFlag extends UserFlagContract {
  VerifiedBotFlag(): super('Verified Bot', 1 << 16, '');
}