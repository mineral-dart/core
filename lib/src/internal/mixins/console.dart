import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Console {
  ConsoleContract get console => ioc.use<MineralCli>().console;
}