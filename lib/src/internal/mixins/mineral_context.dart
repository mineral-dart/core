import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/services/plugin_service.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';
import 'package:mineral_environment/environment.dart';
import 'package:mineral_ioc/ioc.dart';

mixin MineralContext {
  /// Represents your Discord application, the client is null until the ReadyEvent is issued
  MineralClient get client => ioc.use<MineralClient>();

  /// Access point to shared reports within your application
  MineralStateContract get states => ioc.use<SharedStateService>();

  /// Access point to the environment variables of your application
  EnvironmentContract get environment => ioc.use<MineralEnvironment>();

  /// Access point to the registered plugins
  PluginServiceContract plugins = ioc.use<PluginServiceCraft>();
}