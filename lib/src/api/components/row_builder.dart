import 'package:mineral/api.dart';
import 'package:mineral/src/api/components/component.dart';

class RowBuilder extends Component {
  List<Component> components = [];

  RowBuilder() : super(type: ComponentType.actionRow);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'components': components.map((Component component) => component.toJson()).toList()
    };
  }

  factory RowBuilder.fromComponents(List<Component> components) {
    return RowBuilder.fromComponents(components);
  }

  factory RowBuilder.fromComponent(Component component) {
    return RowBuilder.fromComponents([component]);
  }

  factory RowBuilder.fromTextInput(TextInputBuilder input) {
    return RowBuilder.fromComponents([input]);
  }
}
