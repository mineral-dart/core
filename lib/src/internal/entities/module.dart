import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';

abstract class MineralModule {
  final String identifier;
  final String label;
  final String? description;

  MineralModule(this.identifier, this.label, this.description);

  late final EventService events;
  late final CommandService commands;
  late final SharedStateService states;
  late final ContextMenuService contextMenus;

  Future<void> init ();
}
