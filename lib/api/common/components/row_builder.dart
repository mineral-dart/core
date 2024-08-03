import 'package:mineral/api/common/components/component_type.dart';
import 'package:mineral/api/common/components/message_component.dart';

final class RowBuilder implements MessageComponent {
  final List<MessageComponent> _components = [];

  RowBuilder();

  void addComponent(MessageComponent component) {
    if (_components.length >= 5) {
      throw FormatException('A row can only have 5 components');
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
