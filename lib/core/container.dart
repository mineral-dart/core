import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart'
    as env_service;
import 'package:mineral/infrastructure/services/logger/logger.dart'
    as logger_service;

mixin Logger {
  logger_service.LoggerContract get logger =>
      ioc.resolve<logger_service.LoggerContract>();
}

mixin Environment {
  env_service.EnvContract get env => ioc.resolve<env_service.EnvContract>();
}
