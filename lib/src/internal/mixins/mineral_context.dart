import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';
import 'package:mineral/src/internal/services/environment.dart';
import 'package:mineral_ioc/ioc.dart';

mixin MineralContext {
  MineralClient get client => ioc.use<MineralClient>();
  MineralStateContract get states => ioc.use<StateManager>();
  EnvironmentContract get environment => ioc.use<Environment>();
}