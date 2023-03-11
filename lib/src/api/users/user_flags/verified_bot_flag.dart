import 'package:mineral/core/api.dart';

class VerifiedBotFlag extends UserFlagContract {
  VerifiedBotFlag(): super('Verified Bot', 1 << 16, '');
}