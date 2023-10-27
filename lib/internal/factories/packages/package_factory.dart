import 'package:logging/logging.dart';
import 'package:mineral/internal/factories/packages/contracts/package_contract.dart';

final class PackageFactory {
  final Logger _logger;
  final List<PackageContract Function()> packages = [];

  PackageFactory(this._logger);

  void init() {
    for (final package in packages) {
      final instance = package();
      _logger.fine('Initializing package: ${instance.packageName}');

      instance.init();
    }
  }
}