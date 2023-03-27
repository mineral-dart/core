import 'package:mineral_ioc/ioc.dart';
import 'package:mineral_contract/mineral_contract.dart';

abstract class PluginServiceContract {}

class PackageService extends MineralService implements PluginServiceContract {
  final List<MineralService> _packages = [];

  PackageService(List<MineralPackageContract> packages): super(inject: true) {
    register(packages);
  }

  void register (List<MineralPackageContract> packages) {
    _packages.addAll(packages);

    for (final package in packages) {
      ioc.bind((ioc) => package);
    }
  }

  Future<void> load () async {
    for (final package in _packages) {
      if (package is MineralPackageContract) {
        await package.init();
      }
    }
  }
}