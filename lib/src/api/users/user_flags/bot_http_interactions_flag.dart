import 'package:mineral/core/api.dart';

/// A flag that indicates that the bot can use HTTP interactions.
class BotHttpInteractionsFlag extends UserFlagContract {
  BotHttpInteractionsFlag(): super('Bot use only HTTP interactions', 1 << 19, '498591d63b352256a1bf18061eff9d57.svg');
}