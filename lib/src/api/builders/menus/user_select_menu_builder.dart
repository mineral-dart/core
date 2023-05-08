import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

/// A builder for [User] select menus component.
class UserSelectMenuBuilder extends SelectMenuBuilder {
  UserSelectMenuBuilder(String customId) : super (customId, ComponentType.userSelect);
}