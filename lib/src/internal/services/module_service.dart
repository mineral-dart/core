import 'package:mineral/core.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/already_exist_exception.dart';
import 'package:mineral_ioc/ioc.dart';

class ModuleService extends MineralService {
  final Map<String, MineralModule> _modules = {};

  ModuleService(): super(inject: true);

  Map<String, MineralModule> get modules => _modules;

  void register (List<MineralModule> mineralModules) {
    for (final moduleClass in mineralModules) {
      if (_modules.containsKey(moduleClass.identifier)) {
        throw AlreadyExistException('Module ${moduleClass.identifier} is already registered, perhaps this is an error.');
      }

      _modules.putIfAbsent(moduleClass.identifier, () => moduleClass);
    }
  }

  Future<void> load (Kernel kernel) async {
    _modules.forEach((key, module) async {
      module
        ..commands = kernel.commands
        ..events = kernel.events
        ..contextMenus = kernel.contextMenus
        ..states = kernel.states;

      await module.init();
    });
  }
}
