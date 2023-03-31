import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';
import 'package:mineral_environment/environment.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:mineral_contract/mineral_contract.dart';

mixin MineralContext {
  /// Represents your Discord application, the client is null until the ReadyEvent is issued
  MineralClient get client => ioc.use<MineralClient>();

  /// Access point to shared reports within your application
  SharedStateServiceContract get states => ioc.use<SharedStateService>();

  /// Access point to the environment variables of your application
  EnvironmentContract get environment => ioc.use<MineralEnvironment>();
}