library container;

import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart'
    as logger_service;
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/environment/environment.dart'
    as env_service;

export 'package:mineral/src/domains/global_states/global_state_manager.dart'
    show GlobalStateService;
export 'package:mineral/src/infrastructure/internals/container/ioc_container.dart'
    show ioc;

mixin InjectLogger {
  logger_service.LoggerContract get logger =>
      ioc.resolve<logger_service.LoggerContract>();
}

mixin InjectEnvironment {
  env_service.EnvContract get env => ioc.resolve<env_service.EnvContract>();
}

mixin InjectState {
  GlobalStateService get state => ioc.resolve<GlobalStateService>();
}
