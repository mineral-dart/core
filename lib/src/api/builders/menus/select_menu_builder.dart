import 'package:mineral/src/api/builders/component_wrapper.dart';

/// A builder for select menus component.
class SelectMenuBuilder extends ComponentWrapper {
  final String _customId;
  String? _placeholder;
  int? _minValues;
  int? _maxValues;
  bool _disabled = false;

  SelectMenuBuilder(this._customId, ComponentType componentType) : super(type: componentType);

  /// Sets the placeholder text shown on the menu.
  void setPlaceholder (String value) => _placeholder = value;

  /// Sets the disabled state of the menu.
  void setDisabled (bool value) => _disabled = value;

  /// Sets the minimum number of items that must be chosen; default 1, min 0, max 25.
  void setMinValues (int value) => _minValues = value;

  /// Sets the maximum number of items that can be chosen; default 1, max 25.
  void setMaxValues (int value) => _maxValues = value;

  /// Serialize this component to a JSON object.
  @override
  Map<String, dynamic> toJson () {
    return {
      'type': type?.value,
      'custom_id': _customId,
      'placeholder': _placeholder,
      'min_values': _minValues,
      'max_values': _maxValues,
      'disabled': _disabled,
    };
  }
}
