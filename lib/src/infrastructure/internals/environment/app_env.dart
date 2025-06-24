import 'package:env_guard/env_guard.dart';
import 'package:mineral/contracts.dart';

enum DartEnv implements Enumerable<String> {
  development('development'),
  production('production');

  @override
  final String value;

  const DartEnv(this.value);
}

final class AppEnv implements DefineEnvironment {
  static final String dartEnv = 'DART_ENV';
  static final String token = 'TOKEN';
  static final String discordRestHttpVersion = 'DISCORD_REST_API_VERSION';
  static final String discordWssVersion = 'DISCORD_WS_VERSION';
  static final String intent = 'INTENT';
  static final String logLevel = 'LOG_LEVEL';

  @override
  final Map<String, EnvSchema> schema = {
    dartEnv: env.enumerable(DartEnv.values),
    token: env.string(),
    discordRestHttpVersion: env.number(),
    discordWssVersion: env.number(),
    intent: env.number(),
    logLevel: env.enumerable(LogLevel.values),
  };
}
