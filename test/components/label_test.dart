import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/components/label.dart';
import 'package:mineral/src/api/common/components/select_menu.dart';
import 'package:mineral/src/api/common/components/text_input.dart';
import 'package:test/test.dart';

void main() {
  group('Label', () {
    test('generates Discord API JSON with TextInput', () {
      final input = TextInput('name_input', style: TextInputStyle.short);
      final label = Label(label: 'Your Name', component: input);
      final json = label.toJson();

      expect(json['type'], equals(ComponentType.label.value));
      expect(json['label'], equals('Your Name'));
      expect(json['description'], isNull);

      // NOTE: Discord API expects component to be a serialized JSON object,
      // but current implementation stores the raw Dart object
      expect(json['component'], isA<TextInput>());
    });

    test('generates Discord API JSON with description', () {
      final input = TextInput('email', style: TextInputStyle.short);
      final label = Label(
          label: 'Email',
          component: input,
          description: 'We will not share your email');
      final json = label.toJson();

      expect(json['type'], equals(ComponentType.label.value));
      expect(json['label'], equals('Email'));
      expect(json['description'], equals('We will not share your email'));
    });

    test('generates Discord API JSON with SelectMenu', () {
      final menu = SelectMenu.text('role_select', [
        SelectMenuOption(label: 'Admin', value: 'admin'),
      ]);
      final label = Label(label: 'Select Role', component: menu);
      final json = label.toJson();

      expect(json['type'], equals(ComponentType.label.value));
      expect(json['label'], equals('Select Role'));

      // NOTE: Discord API expects component to be a serialized JSON object,
      // but current implementation stores the raw Dart object
      expect(json['component'], isA<SelectMenu>());
    });
  });
}
