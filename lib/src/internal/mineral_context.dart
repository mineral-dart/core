import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';

mixin MineralContext {
  MineralClient get client => ioc.singleton(Service.client);
  StateManager get stores => ioc.singleton(Service.store);
  Environment get environment => ioc.singleton(Service.environment);
}