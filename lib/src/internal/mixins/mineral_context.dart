import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';
import 'package:mineral_ioc/ioc.dart';

mixin MineralContext {
  MineralClient get client => ioc.use<MineralClient>();
  StateManager get stores => ioc.use<StateManager>();
  Environment get environment => ioc.use<Environment>();
}