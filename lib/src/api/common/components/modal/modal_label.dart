import '../component.dart';
import '../component_type.dart';

final class ModalLabel implements Component {
  ComponentType get type => ComponentType.label;

  final String _label;
  final Component _component;
  final String? _description;

  ModalLabel(
      {required String label,
      required Component component,
      String? description})
      : _label = label,
        _component = component,
        _description = description;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'label': _label,
      if (_description != null) 'description': _description,
      'component': _component,
    };
  }
}
