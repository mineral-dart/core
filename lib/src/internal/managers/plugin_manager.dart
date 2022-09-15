import 'dart:io';

import 'package:mineral_ioc/ioc.dart';

class PluginManager {
  void use (List plugins) {
    for (final plugin in plugins) {
      ioc.bind(namespace: 'Mineral/Plugins/${plugin.label}', service: plugin);
      plugin..root = Directory.current
        ..init();
    }
  }
}
