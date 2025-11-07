import 'package:mineral/api.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';

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
      'description': Helper.createOrNull(
        field: description,
        fn: () => description,
      ),
      'component': component,
    };
  }
}
