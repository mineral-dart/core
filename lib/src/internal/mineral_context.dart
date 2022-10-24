import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

mixin MineralContext {
  MineralClient get client => ioc.singleton(Service.client);
  StoreManager get stores => ioc.singleton(Service.store);
  Environment get environment => ioc.singleton(Service.environment);
}