import 'package:mineral/infrastructure/internals/environment/environment.dart' as env_service;
import 'package:mineral/infrastructure/services/logger/logger.dart' as logger_service;

mixin Logger {
  logger_service.LoggerContract get logger => logger_service.Logger.singleton();
}

mixin Environment {
  env_service.EnvContract get env => env_service.Environment.singleton();
}
