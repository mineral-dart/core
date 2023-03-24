import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/role_menu_interaction.dart';

class RoleMenuCreateEvent extends Event {
  final RoleMenuInteraction _interaction;

  RoleMenuCreateEvent(this._interaction);

  RoleMenuInteraction get interaction => _interaction;
}
