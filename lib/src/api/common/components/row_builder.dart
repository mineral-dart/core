import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/infrastructure/io/exceptions/too_many_element_exception.dart';

final class RowBuilder implements MessageComponent {
  final List<MessageComponent> _components = [];

  RowBuilder();

  void addComponent(MessageComponent component) {
    if (component is RowBuilder) {
      throw Exception('You can not add a RowBuilder to another RowBuilder.');
    }

    if (_components.length >= 5) {
      throw TooManyElementException(
          'You give ${_components.length + 1} components but this row can only have 5.');
    }

    _components.add(component);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ComponentType.actionRow.value,
      'components': _components.map((e) => e.toJson()).toList(),
    };
  }
}
