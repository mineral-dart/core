import 'dart:mirrors';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

import 'event_manager.dart';

class ModuleManager {
  final Map<String, MineralModule> _modules = {};
  Map<String, MineralModule> get modules => _modules;

  ModuleManager add (MineralModule module, { String? overrideIdentifier }) {
    Module moduleDecorator = reflect(module).type.metadata.first.reflectee;
    module..identifier = moduleDecorator.identifier
      ..label = moduleDecorator.label
      ..description = moduleDecorator.description;

    if (_modules.containsKey(moduleDecorator.identifier)) {
      if (overrideIdentifier != null) {
        _modules.putIfAbsent(overrideIdentifier, () => module);
      } else {
        throw AlreadyExist(cause: 'Module ${moduleDecorator.identifier} is already registered, perhaps this is an error. If not, please change the name of the module when you register it.');
      }
    } else {
      _modules.putIfAbsent(moduleDecorator.identifier, () => module);
    }

    return this;
  }

  Future<void> load () async {
    EventManager eventManager = ioc.singleton(ioc.services.event);
    CommandManager commandManager = ioc.singleton(ioc.services.command);
    StoreManager storeManager = ioc.singleton(ioc.services.store);
    ContextMenuManager contextMenuManager = ioc.singleton(ioc.services.contextMenu);

    _modules.forEach((key, module) async {
      await module.init();

      for (MineralEvent event in module.events) {
        eventManager.add(event);
      }

      for (MineralCommand command in module.commands) {
        commandManager.add(command);
      }

      for (MineralStore store in module.stores) {
        storeManager.add(store);
      }

      for (MineralContextMenu contextMenu in module.contextMenu) {
        contextMenuManager.add(contextMenu);
      }

      Console.debug(
        prefix: 'Loading module',
        message: '"${module.label}" with ${module.events.length} events, ${module.commands.length} commands and ${module.stores.length} stores.'
      );
    });
  }
}
