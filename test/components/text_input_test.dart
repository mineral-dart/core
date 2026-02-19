import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/components/text_input.dart';
import 'package:test/test.dart';

void main() {
  group('TextInput', () {
    test('generates valid Discord API JSON with minimal fields', () {
      final input = TextInput('username', style: TextInputStyle.short);

      // NOTE: Discord API treats min_length, max_length, placeholder, value, required
      // as optional (absent when not set), but current implementation always emits them as null
      expect(
          input.toJson(),
          equals({
            'type': ComponentType.textInput.value,
            'custom_id': 'username',
            'style': 1,
            'min_length': null,
            'max_length': null,
            'placeholder': null,
            'value': null,
            'required': null,
          }));
    });

    test('generates valid Discord API JSON with all fields', () {
      final input = TextInput(
        'feedback',
        style: TextInputStyle.paragraph,
        minLength: 10,
        maxLength: 500,
        placeholder: 'Tell us what you think...',
        value: 'Pre-filled text',
        isRequired: true,
      );

      expect(
          input.toJson(),
          equals({
            'type': ComponentType.textInput.value,
            'custom_id': 'feedback',
            'style': 2,
            'min_length': 10,
            'max_length': 500,
            'placeholder': 'Tell us what you think...',
            'value': 'Pre-filled text',
            'required': true,
          }));
    });

    test('generates valid Discord API JSON with short style', () {
      final input = TextInput('name', style: TextInputStyle.short);

      expect(input.toJson()['style'], equals(1));
    });

    test('generates valid Discord API JSON with paragraph style', () {
      final input = TextInput('bio', style: TextInputStyle.paragraph);

      expect(input.toJson()['style'], equals(2));
    });

    test('generates valid Discord API JSON with required false', () {
      final input =
          TextInput('optional', style: TextInputStyle.short, isRequired: false);

      expect(input.toJson()['required'], equals(false));
    });
  });
}
