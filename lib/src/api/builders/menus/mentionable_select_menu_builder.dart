import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

/// A builder for mentionable select menus component.
class MentionableSelectMenuBuilder extends SelectMenuBuilder {
  MentionableSelectMenuBuilder(String customId) : super (customId, ComponentType.mentionableSelect);
}