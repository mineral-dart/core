import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';

abstract class MineralModule {
  final String identifier;
  final String label;
  final String? description;

  MineralModule(this.identifier, this.label, this.description);

  late final EventService events;
  late final CommandManager commands;
  late final StateManager states;
  late final ContextMenuService contextMenus;

  Future<void> init ();
}
