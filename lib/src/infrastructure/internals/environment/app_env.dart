import 'package:mineral/src/domains/contracts/environment/env_schema.dart';

enum AppEnv implements EnvSchema {
  dartEnv('DART_ENV', required: true),
  token('TOKEN', required: true),
  httpVersion('HTTP_VERSION', required: true),
  wssVersion('WSS_VERSION', required: true),
  intent('INTENT', required: true),
  logLevel('LOG_LEVEL', required: true);

  @override
  final String key;

  @override
  final bool required;

  const AppEnv(this.key, {required this.required});
}
