import 'package:mineral/src/api/builders/component_wrapper.dart';

class SelectMenuBuilder extends ComponentWrapper {
  final String _customId;
  String? _placeholder;
  int? _minValues;
  int? _maxValues;
  bool _disabled = false;

  SelectMenuBuilder(this._customId, ComponentType componentType) : super(type: componentType);

  void setPlaceholder (String value) => _placeholder = value;

  void setDisabled (bool value) => _disabled = value;

  void setMinValues (int value) => _minValues = value;

  void setMaxValues (int value) => _maxValues = value;

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
