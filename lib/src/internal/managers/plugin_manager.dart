import 'package:mineral_ioc/ioc.dart';
import 'package:mineral_package/mineral_package.dart';

class PluginManager {
  final List<MineralPackage> _plugins = [];

  void use (List<MineralPackage> plugins) {
    _plugins.addAll(plugins);
  }

  Future<void> load () async {
    for (final plugin in _plugins) {
      ioc.bind(namespace: plugin.namespace, service: plugin);
      await plugin.init();
    }
  }
}
