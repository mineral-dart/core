import 'package:mineral_ioc/ioc.dart';
import 'package:mineral_package/mineral_package.dart';

abstract class PluginServiceContract {
  T use<T extends MineralPackage> ();
}

abstract class PluginService extends MineralService implements PluginServiceContract {
  final Map<Type, MineralPackage> _plugins = {};

  PluginService(): super(inject: true);

  @override
  T use<T extends MineralPackage> () {
    final package =  _plugins[T];
    if (package == null) {
      throw Exception('The $T package was not registered');
    }

    return _plugins[T] as T;
  }
}

class PluginServiceCraft extends PluginService {
  void register (List<MineralPackage> plugins) {
    for (final plugin in plugins) {
      _plugins.putIfAbsent(plugin.runtimeType, () => plugin);
    }
  }

  Future<void> load () async {
    for (final plugin in _plugins.values) {
      await plugin.init();
    }
  }
}
