import 'package:mineral/core/services.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

mixin State {
  /// Access point to shared reports within your application
  SharedStateServiceContract get states => ioc.use<SharedStateService>();
}