import 'package:mineral/src/api/components/component.dart';

enum TextInputStyle {
  input(1),
  paragraph(2);

  final int value;
  const TextInputStyle(this.value);

  @override
  String toString () => value.toString();
}

class TextInputBuilder extends Component {
  String customId;
  String label;
  TextInputStyle style;
  int? minLength;
  int? maxLength;
  bool required = false;
  String? placeholder;
  String? value;

  TextInputBuilder({
    required this.customId,
    required this.label,
    required this.style,
    this.minLength,
    this.maxLength,
    this.required = false,
    this.placeholder,
    this.value,
  }) : super(type: ComponentType.textInput);

  @override
  Object toJson () {
    return {
      'type': ComponentType.textInput.value,
      'custom_id': customId,
      'style': style.value,
      'label': label,
      'min_length': minLength ?? 1,
      'max_length': maxLength ?? 4000,
      'required': required,
      'value': value,
      'placeholder': placeholder,
    };
  }
}
