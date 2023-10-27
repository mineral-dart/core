import 'package:mineral/internal/services/console/console.dart';

abstract class PackageContract {
  final String packageName;

  PackageContract({ required this.packageName });

  Future<void> init ();
  Future<void> initConsole(Console console);
  Future<void> configure();
}