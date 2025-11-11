import 'package:mineral/api.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';

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
      'min_length': Helper.createOrNull(
        field: minLength,
        fn: () => minLength,
      ),
      'max_length': Helper.createOrNull(
        field: maxLength,
        fn: () => maxLength,
      ),
      'placeholder': Helper.createOrNull(
        field: placeholder,
        fn: () => placeholder,
      ),
      'value': Helper.createOrNull(
        field: value,
        fn: () => value,
      ),
      'required': Helper.createOrNull(
        field: isRequired,
        fn: () => isRequired,
      ),
    };
  }
}
