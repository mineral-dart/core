import 'package:mineral/src/api/components/component.dart';

class Row extends Component {
  List<Component>? components = [];

  Row({ this.components }) : super(type: ComponentType.actionRow);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'components': components?.map((Component component) => component.toJson()).toList()
    };
  }

  factory Row.from({ required dynamic payload }) {
    return Row();
  }
}
