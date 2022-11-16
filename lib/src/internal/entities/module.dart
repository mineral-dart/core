import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';

abstract class MineralModule {
  final String identifier;
  final String label;
  final String? description;

  MineralModule(this.identifier, this.label, this.description);

  late final EventManager events;
  late final CommandManager commands;
  late final StateManager states;
  late final ContextMenuManager contextMenus;

  Future<void> init ();
}
