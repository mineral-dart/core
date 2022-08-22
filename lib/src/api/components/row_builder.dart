import 'package:mineral/api.dart';
import 'package:mineral/src/api/components/component.dart';

class RowBuilder extends Component {
  List<Component>? components = [];

  RowBuilder({ this.components }) : super(type: ComponentType.actionRow);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'components': components?.map((Component component) => component.toJson()).toList()
    };
  }

  factory RowBuilder.fromComponents(List<Component> components) {
    return RowBuilder(components: components);
  }

  factory RowBuilder.fromTextInput(TextInputBuilder input) {
    return RowBuilder(components: [input]);
  }
}
