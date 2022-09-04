import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

class Module {
  final String identifier;
  final String label;
  final String? description;

  const Module({ required this.identifier, required this.label, this.description });
}

abstract class MineralModule {
  late final String identifier;
  late final String label;
  late final String? description;

  late final EventManager events;
  late final CommandManager commands;
  late final StoreManager stores;
  late final ContextMenuManager contextMenus;

  Future<void> init ();
}
