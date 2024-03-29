import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Console {
  /// Returns the console service.
  ConsoleServiceContract get console => ioc.use<ConsoleService>();
}