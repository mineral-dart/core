import 'package:mineral/core/services.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Component {
  /// Returns the component service.
  ComponentServiceContract get components => ioc.use<ComponentService>();
}