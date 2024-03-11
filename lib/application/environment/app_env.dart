import 'package:mineral/application/environment/env_schema.dart';

enum AppEnv implements EnvSchema {
  token('TOKEN'),
  httpVersion('HTTP_VERSION'),
  wssVersion('WSS_VERSION'),
  intent('INTENT'),
  logLevel('LOG_LEVEL');

  @override
  final String key;

  const AppEnv(this.key);
}
