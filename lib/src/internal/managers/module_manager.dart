import 'dart:mirrors';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/already_exist.dart';

class ModuleManager {
  final Map<String, MineralModule> _modules = {};
  Map<String, MineralModule> get modules => _modules;

  void register (List<MineralModule> mineralModules) {
    for (final moduleClass in mineralModules) {
      Module moduleDecorator = reflect(moduleClass).type.metadata.first.reflectee;

      moduleClass
        ..identifier = moduleDecorator.identifier
        ..label = moduleDecorator.label
        ..description = moduleDecorator.description;

      if (_modules.containsKey(moduleDecorator.identifier)) {
        throw AlreadyExist(cause: 'Module ${moduleDecorator.identifier} is already registered, perhaps this is an error.');
      }

      _modules.putIfAbsent(moduleDecorator.identifier, () => moduleClass);
    }
  }

  Future<void> load (Kernel kernel) async {
    _modules.forEach((key, module) async {
      module
        ..commands = kernel.commands
        ..events = kernel.events
        ..contextMenus = kernel.contextMenus
        ..stores = kernel.stores;

      await module.init();

      Console.debug(
        prefix: 'Loading module',
        message: '"${module.label}" is ready to use.'
      );
    });
  }
}
