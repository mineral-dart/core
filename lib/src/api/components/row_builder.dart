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

  factory RowBuilder.from({ required dynamic payload }) {
    return RowBuilder();
  }
}
