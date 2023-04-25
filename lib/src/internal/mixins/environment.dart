import 'package:mineral/src/internal/services/environment_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Environment {
  /// Access point to the environment variables of your application
  EnvironmentServiceContract get environment => ioc.use<EnvironmentService>();
}