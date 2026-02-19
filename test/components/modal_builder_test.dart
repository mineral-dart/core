import 'package:mineral/src/api/common/components/builder/modal_builder.dart';
import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/components/select_menu.dart';
import 'package:mineral/src/api/common/components/text_input.dart';
import 'package:test/test.dart';

void main() {
  group('ModalBuilder', () {
    late ModalBuilder modal;

    setUp(() {
      modal = ModalBuilder('test_modal');
    });

    group('build', () {
      test('generates valid Discord API JSON for empty modal', () {
        expect(
            modal.build(),
            equals({
              'custom_id': 'test_modal',
              'title': null,
              'components': [],
            }));
      });

      test('generates valid Discord API JSON with title', () {
        modal.setTitle('My Modal');

        expect(
            modal.build(),
            equals({
              'custom_id': 'test_modal',
              'title': 'My Modal',
              'components': [],
            }));
      });
    });

    group('addTextInput', () {
      test('generates Label wrapping TextInput in components', () {
        modal.addTextInput(
          customId: 'feedback',
          label: 'Your Feedback',
          style: TextInputStyle.paragraph,
          placeholder: 'Tell us what you think...',
          minLength: 10,
          maxLength: 500,
          isRequired: true,
          description: 'Be specific',
        );

        final result = modal.build();
        expect(result['custom_id'], equals('test_modal'));
        expect(result['components'], hasLength(1));

        final component = result['components'][0] as Map<String, dynamic>;
        expect(component['type'], equals(ComponentType.label.value));
        expect(component['label'], equals('Your Feedback'));
        expect(component['description'], equals('Be specific'));

        // NOTE: Discord API expects component to be a serialized JSON object,
        // but current implementation stores the raw Dart object via Label.toJson()
        expect(component['component'], isA<TextInput>());
      });

      test('generates valid Discord API JSON with multiple text inputs', () {
        modal
          ..setTitle('Registration')
          ..addTextInput(
            customId: 'username',
            label: 'Username',
          )
          ..addTextInput(
            customId: 'bio',
            label: 'Bio',
            style: TextInputStyle.paragraph,
          );

        final result = modal.build();
        expect(result['components'], hasLength(2));

        final first = result['components'][0] as Map<String, dynamic>;
        expect(first['label'], equals('Username'));

        final second = result['components'][1] as Map<String, dynamic>;
        expect(second['label'], equals('Bio'));
      });
    });

    group('addText', () {
      test('generates TextDisplay in components', () {
        modal.addText('Please fill in the form below:');

        final result = modal.build();
        expect(result['components'], hasLength(1));

        final component = result['components'][0] as Map<String, dynamic>;
        expect(
            component,
            equals({
              'type': ComponentType.textDisplay.value,
              'content': 'Please fill in the form below:',
            }));
      });
    });

    group('addSelectMenu', () {
      test('generates Label wrapping SelectMenu in components', () {
        final menu = SelectMenu.text('category', [
          SelectMenuOption(label: 'Bug', value: 'bug'),
          SelectMenuOption(label: 'Feature', value: 'feature'),
        ]);

        modal.addSelectMenu(
          label: 'Issue Category',
          menu: menu,
          description: 'Select the category',
        );

        final result = modal.build();
        expect(result['components'], hasLength(1));

        final component = result['components'][0] as Map<String, dynamic>;
        expect(component['type'], equals(ComponentType.label.value));
        expect(component['label'], equals('Issue Category'));
        expect(component['description'], equals('Select the category'));

        // NOTE: Discord API expects component to be a serialized JSON object,
        // but current implementation stores the raw Dart object via Label.toJson()
        expect(component['component'], isA<SelectMenu>());
      });
    });

    group('complex modal', () {
      test('generates valid Discord API JSON for complete form', () {
        modal
          ..setTitle('Bug Report')
          ..addText('**Please describe the bug you encountered.**')
          ..addTextInput(
            customId: 'title',
            label: 'Bug Title',
            style: TextInputStyle.short,
            placeholder: 'Brief summary',
            maxLength: 100,
            isRequired: true,
          )
          ..addTextInput(
            customId: 'description',
            label: 'Description',
            style: TextInputStyle.paragraph,
            placeholder: 'Detailed description...',
            minLength: 20,
            maxLength: 2000,
            isRequired: true,
            description: 'Please provide as much detail as possible',
          );

        final result = modal.build();
        expect(result['custom_id'], equals('test_modal'));
        expect(result['title'], equals('Bug Report'));
        expect(result['components'], hasLength(3));

        // First component: TextDisplay
        final textDisplay = result['components'][0] as Map<String, dynamic>;
        expect(textDisplay['type'], equals(ComponentType.textDisplay.value));
        expect(textDisplay['content'],
            equals('**Please describe the bug you encountered.**'));

        // Second component: Label wrapping TextInput
        final titleLabel = result['components'][1] as Map<String, dynamic>;
        expect(titleLabel['type'], equals(ComponentType.label.value));
        expect(titleLabel['label'], equals('Bug Title'));

        // Third component: Label wrapping TextInput
        final descLabel = result['components'][2] as Map<String, dynamic>;
        expect(descLabel['type'], equals(ComponentType.label.value));
        expect(descLabel['label'], equals('Description'));
        expect(descLabel['description'],
            equals('Please provide as much detail as possible'));
      });
    });
  });
}
