import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/modal/text_input_style.dart';

/// A builder for input component.
class InputBuilder {
  final String _customId;
  final TextInputStyle _style;
  String _label = '';
  bool _required = false;
  int? _minLength;
  int? _maxLength;
  String? _placeholder;
  String? value;

  InputBuilder(this._customId, this._style);

  /// Gets the label of this.
  String get customId => _customId;

  /// Gets the [TextInputStyle] of this.
  TextInputStyle get style => _style;

  /// Gets the label of this.
  String get label => _label;

  /// Gets the required state of this.
  bool get required => _required;

  /// Gets the minimum length of this.
  int? get minLength => _minLength;

  /// Gets the maximum length of this.
  int? get maxLength => _maxLength;

  /// Gets the placeholder of this.
  String? get placeholder => _placeholder;

  /// Sets the label of this.
  void setLabel(String value) => _label = value;

  /// Sets the required state of this.
  void setRequired(bool value) => _required = value;

  /// Sets the minimum length of this.
  void setMinLength(int value) => _minLength = value;

  /// Sets the maximum length of this.
  void setMaxLength(int value) => _maxLength = value;

  /// Sets the placeholder of this.
  void setPlaceholder(String value) => _placeholder = value;

  /// Serialize this component to a JSON object.
  Map<String, dynamic> toJson () => {
    'label': _label,
    'type': ComponentType.textInput.value,
    'style': _style.value,
    'required': _required,
    'custom_id': _customId,
    'min_length': _minLength,
    'max_length': _maxLength,
    'placeholder': _placeholder
  };
}