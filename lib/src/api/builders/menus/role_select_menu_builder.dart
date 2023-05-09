import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

/// A builder for [Role] select menus component.
class RoleSelectMenuBuilder extends SelectMenuBuilder {
  RoleSelectMenuBuilder(String customId) : super(customId, ComponentType.roleSelect);
}