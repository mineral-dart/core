import 'package:logging/logging.dart';
import 'package:mineral/internal/factories/packages/contracts/package_contract.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:mineral/internal/services/console/console.dart';

final class PackageFactory extends Injectable {
  final Logger _logger;
  final List<PackageContract> packages = [];

  PackageFactory(this._logger);

  void register (PackageContract Function() package) {
    packages.add(package());
  }

  void registerMany (List<PackageContract Function()> packages) {
    for (final package in packages) {
      register(package);
    }
  }

  void init() {
    for (final package in packages) {
      _logger.fine('Initializing package: ${package.packageName}');
      package.init();
    }
  }

  void initConsole() {
    for (final package in packages) {
      _logger.fine('Initializing package console: ${package.packageName}');
      package.initConsole(Console.singleton());
    }
  }

  factory PackageFactory.singleton() => container.use('Mineral/Factories/Package');
}