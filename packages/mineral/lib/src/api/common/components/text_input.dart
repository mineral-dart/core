import 'package:mineral/api.dart';

enum TextInputStyle implements EnhancedEnum<int> {
  short(1),
  paragraph(2);

  @override
  final int value;

  const TextInputStyle(this.value);
}

final class TextInput implements ModalComponent {
  ComponentType get type => ComponentType.textInput;

  final String customId;
  final TextInputStyle style;
  final int? minLength;
  final int? maxLength;
  final bool? isRequired;
  final String? value;
  final String? placeholder;

  TextInput(
    this.customId, {
    required this.style,
    this.minLength,
    this.maxLength,
    this.isRequired,
    this.value,
    this.placeholder,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'custom_id': customId,
      'style': style.value,
      if (minLength != null) 'min_length': minLength,
      if (maxLength != null) 'max_length': maxLength,
      if (placeholder != null) 'placeholder': placeholder,
      if (value != null) 'value': value,
      if (isRequired != null) 'required': isRequired,
    };
  }
}
