import '../../types/enhanced_enum.dart';

import '../component.dart';
import '../component_type.dart';

enum ModalTextInputStyle implements EnhancedEnum<int> {
  short(1),
  paragraph(2);

  @override
  final int value;

  const ModalTextInputStyle(this.value);
}

final class ModalTextInput implements Component {
  ComponentType get type => ComponentType.textInput;

  final String _customId;
  final ModalTextInputStyle style;
  final int? _minLength;
  final int? _maxLength;
  final bool? _required;
  final String? _value;
  final String? _placeholder;

  ModalTextInput(
    this._customId, {
    required this.style,
    int? minLength,
    int? maxLength,
    bool? required,
    String? value,
    String? placeholder,
  })  : _minLength = minLength,
        _maxLength = maxLength,
        _required = required,
        _value = value,
        _placeholder = placeholder;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'custom_id': _customId,
      'style': style.value,
      if (_minLength != null) 'min_length': _minLength,
      if (_maxLength != null) 'max_length': _maxLength,
      if (_placeholder != null) 'placeholder': _placeholder,
      if (_value != null) 'value': _value,
      if (_required != null) 'required': _required,
    };
  }
}
