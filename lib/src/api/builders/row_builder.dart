import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_builder.dart';

class RowBuilder extends ComponentBuilder {
  List<ComponentBuilder> components = [];

  RowBuilder() : super(type: ComponentType.actionRow);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'components': components.map((ComponentBuilder component) => component.toJson()).toList()
    };
  }

  factory RowBuilder.fromComponents(List<ComponentBuilder> components) {
    return RowBuilder()
      ..components = components;
  }

  factory RowBuilder.fromComponent(ComponentBuilder component) {
    return RowBuilder.fromComponents([component]);
  }

  factory RowBuilder.fromTextInput(TextInputBuilder input) {
    return RowBuilder.fromComponents([input]);
  }
}
