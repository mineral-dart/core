library container;

import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/environment/environment.dart'
    as env_service;
import 'package:mineral/src/infrastructure/services/logger/logger.dart'
    as logger_service;

export 'package:mineral/src/infrastructure/internals/container/ioc_container.dart'
    show ioc;

mixin InjectLogger {
  logger_service.LoggerContract get logger =>
      ioc.resolve<logger_service.LoggerContract>();
}

mixin InjectEnvironment {
  env_service.EnvContract get env => ioc.resolve<env_service.EnvContract>();
}
