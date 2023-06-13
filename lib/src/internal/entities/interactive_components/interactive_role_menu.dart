import 'package:mineral/core/builders.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/api/collectors/interaction_collector.dart';
import 'package:mineral/src/internal/entities/interactive_components/interactive_component.dart';

abstract class InteractiveRoleMenu extends InteractiveComponent<RoleSelectMenuBuilder, RoleMenuCreateEvent> {
  InteractiveRoleMenu(super.customId, { bool standalone = false }) {
    if (standalone) {
      InteractionCollector<RoleMenuCreateEvent>(customId).collect().then((value) async {
        await handle(value);
      });
    }
  }
}