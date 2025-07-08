import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/message_components/dialogs/dialog_element_type.dart';

abstract interface class DialogElement implements MessageComponent {}

final class DialogElementBuilder {
  static DialogTextInput input(String customId) => DialogTextInput(customId);
  static DialogParagraphInput paragraph(String customId) =>
      DialogParagraphInput(customId);
}

final class DialogTextInput with DialogElementImpl implements DialogElement {
  final String _customId;

  DialogTextInput(this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.textInput.value,
      'style': DialogElementType.text.value,
      'custom_id': _customId,
    };
  }
}

final class DialogParagraphInput
    with DialogElementImpl
    implements DialogElement {
  final String _customId;

  DialogParagraphInput(this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': ComponentType.textInput.value,
      'style': DialogElementType.paragraph.value,
      'custom_id': _customId,
    };
  }
}

mixin DialogElementImpl<T extends DialogElement> {
  String? _label;
  String? _placeholder;
  bool? _required;
  int? _minLength;
  int? _maxLength;
  String? _defaultValue;

  T setLabel(String label) {
    _label = label;
    return this as T;
  }

  T setPlaceholder(String placeholder) {
    _placeholder = placeholder;
    return this as T;
  }

  T setConstraint({int? minLength, int? maxLength, bool? required}) {
    _minLength = minLength ?? _minLength;
    _maxLength = maxLength ?? _maxLength;
    _required = required ?? _required;

    return this as T;
  }

  T setDefaultValue(String value) {
    _defaultValue = value;
    return this as T;
  }

  Map<String, dynamic> toJson() {
    return {
      'label': _label,
      'placeholder': _placeholder,
      'required': _required,
      'min_length': _minLength,
      'max_length': _maxLength,
      'value': _defaultValue,
    };
  }
}

final class DialogFieldConstraint {
  final int? minLength;
  final int? maxLength;
  final bool? required;

  DialogFieldConstraint({this.minLength, this.maxLength, this.required});
}
