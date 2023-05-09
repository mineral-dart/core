import 'package:mineral/src/api/builders/component_wrapper.dart';

/// Split [ComponentBuilder] into multiple rows.
class RowBuilder extends ComponentWrapper {
  /// The [ComponentBuilder] of this as [List].
  List components;

  RowBuilder(this.components) : super(type: ComponentType.actionRow);

  /// Serialize this to json.
  @override
  Object toJson () => {
    'type': type?.value,
    'components': components.map((dynamic component) => component.toJson()).toList()
  };
}
