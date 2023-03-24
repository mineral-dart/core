import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';

class RowBuilder extends ComponentWrapper {
  List components;

  RowBuilder(this.components) : super(type: ComponentType.actionRow);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'components': components.map((dynamic component) => component.toJson()).toList()
    };
  }

  factory RowBuilder.fromTextInput(TextInputBuilder input) {
    return RowBuilder([input]);
  }
}
