import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/services/env/environment.dart';

abstract class ApplicationConfigContract {
  final String token;
  final Intents intents;

  Environment get env => Environment.singleton();

  ApplicationConfigContract({
    required this.token,
    required this.intents,
  });
}