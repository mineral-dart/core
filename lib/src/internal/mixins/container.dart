import 'package:mineral_ioc/ioc.dart';

mixin Container {
  /// Service manager including the core components of the Mineral framework
  Ioc get container => ioc;
}