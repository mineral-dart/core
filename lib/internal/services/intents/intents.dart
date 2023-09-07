import 'package:mineral/internal/services/intents/intent.dart';
import 'package:mineral/internal/services/intents/intent_builder.dart';

/// A service that provides intents.
/// Related to official [Discord API](https://discord.com/developers/docs/topics/gateway#gateway-intents) documentation.
class Intents {
  final List<Intent> _intents;
  List<Intent> get intents => _intents;

  Intents._(this._intents);

  /// Creates an [Intents] service with the given intents.
  factory Intents.only(List<Intent> intents) => Intents._(intents);

  /// Creates an [Intents] service with all intents.
  factory Intents.all() => Intents._(Intent.values);

  /// Creates an [Intents] service with no intents.
  factory Intents.none() => Intents._([]);

  /// Creates an [Intents] service with the intents defined in the builder.
  factory Intents.builder(Function(IntentBuilder) builder) => Intents._(builder(IntentBuilder()).intents);
}