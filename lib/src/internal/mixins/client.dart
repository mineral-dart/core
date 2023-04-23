import 'package:mineral/core/api.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Client {
  /// Represents your Discord application, the client is null until the ReadyEvent is issued
  MineralClient get client => ioc.use<MineralClient>();
}