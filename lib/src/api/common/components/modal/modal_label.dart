import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/components/component_type.dart';

final class ModalLabel implements Component {
  ComponentType get type => ComponentType.label;

  final String label;
  final Component component;
  final String? description;

  ModalLabel({
    required this.label,
    required this.component,
    this.description,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'label': label,
      if (description != null) 'description': description,
      'component': component,
    };
  }
}
