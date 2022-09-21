import 'dart:io';
import 'dart:mirrors';

import 'package:mineral_ioc/ioc.dart';

class PluginManager {
  final List _plugins = [];

  void use (List plugins) {
    _plugins.addAll(plugins);
  }

  Future<void> load () async {
    for (final plugin in _plugins) {
      final namespace = reflect(plugin).type.getField(Symbol('namespace'));
      ioc.bind(namespace: namespace.reflectee, service: plugin);

      plugin..root = Directory.current
        ..init();
    }
  }
}
