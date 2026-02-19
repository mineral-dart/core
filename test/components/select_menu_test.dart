import 'package:mineral/src/api/common/components/component.dart';
import 'package:mineral/src/api/common/components/select_menu.dart';
import 'package:mineral/src/api/common/partial_emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:test/test.dart';

void main() {
  group('SelectMenu', () {
    group('SelectMenu.text', () {
      test('generates valid Discord API JSON with options', () {
        final menu = SelectMenu.text(
            'color_select',
            [
              SelectMenuOption(label: 'Red', value: 'red'),
              SelectMenuOption(label: 'Blue', value: 'blue'),
            ],
            placeholder: 'Choose a color');

        // NOTE: Discord API treats placeholder and disabled as optional (absent when not set),
        // but current implementation always emits them
        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.textSelectMenu.value,
              'custom_id': 'color_select',
              'placeholder': 'Choose a color',
              'disabled': null,
              'options': [
                {
                  'label': 'Red',
                  'value': 'red',
                  'description': null,
                  'default': false
                },
                {
                  'label': 'Blue',
                  'value': 'blue',
                  'description': null,
                  'default': false
                },
              ],
            }));
      });

      test('generates valid Discord API JSON without options', () {
        final menu = SelectMenu.text('empty_select', []);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.textSelectMenu.value,
              'custom_id': 'empty_select',
              'placeholder': null,
              'disabled': null,
            }));
      });

      test('generates valid Discord API JSON with min and max values', () {
        final menu = SelectMenu.text(
            'multi_select',
            [
              SelectMenuOption(label: 'A', value: 'a'),
              SelectMenuOption(label: 'B', value: 'b'),
              SelectMenuOption(label: 'C', value: 'c'),
            ],
            minValues: 1,
            maxValues: 2);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.textSelectMenu.value,
              'custom_id': 'multi_select',
              'placeholder': null,
              'disabled': null,
              'min_values': 1,
              'max_values': 2,
              'options': [
                {
                  'label': 'A',
                  'value': 'a',
                  'description': null,
                  'default': false
                },
                {
                  'label': 'B',
                  'value': 'b',
                  'description': null,
                  'default': false
                },
                {
                  'label': 'C',
                  'value': 'c',
                  'description': null,
                  'default': false
                },
              ],
            }));
      });

      test('generates valid Discord API JSON with disabled', () {
        final menu = SelectMenu.text('disabled_select', [], disabled: true);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.textSelectMenu.value,
              'custom_id': 'disabled_select',
              'placeholder': null,
              'disabled': true,
            }));
      });
    });

    group('SelectMenu.user', () {
      test('generates valid Discord API JSON', () {
        final menu = SelectMenu.user('user_select', placeholder: 'Pick a user');

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.userSelectMenu.value,
              'custom_id': 'user_select',
              'placeholder': 'Pick a user',
              'disabled': null,
            }));
      });

      test('generates valid Discord API JSON with default values', () {
        final menu = SelectMenu.user('user_select',
            defaultValues: [Snowflake('123456789')]);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.userSelectMenu.value,
              'custom_id': 'user_select',
              'placeholder': null,
              'disabled': null,
              'default_values': [
                {'id': '123456789', 'type': 'user'},
              ],
            }));
      });
    });

    group('SelectMenu.role', () {
      test('generates valid Discord API JSON', () {
        final menu = SelectMenu.role('role_select');

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.roleSelectMenu.value,
              'custom_id': 'role_select',
              'placeholder': null,
              'disabled': null,
            }));
      });

      test('generates valid Discord API JSON with default values', () {
        final menu = SelectMenu.role('role_select',
            defaultValues: [Snowflake('987654321')]);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.roleSelectMenu.value,
              'custom_id': 'role_select',
              'placeholder': null,
              'disabled': null,
              'default_values': [
                {'id': '987654321', 'type': 'role'},
              ],
            }));
      });
    });

    group('SelectMenu.mentionable', () {
      test('generates valid Discord API JSON', () {
        final menu = SelectMenu.mentionable('mention_select');

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.mentionableSelectMenu.value,
              'custom_id': 'mention_select',
              'placeholder': null,
              'disabled': null,
            }));
      });
    });

    group('SelectMenu.channel', () {
      test('generates valid Discord API JSON', () {
        final menu = SelectMenu.channel('channel_select');

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.channelSelectMenu.value,
              'custom_id': 'channel_select',
              'placeholder': null,
              'disabled': null,
            }));
      });

      test('generates valid Discord API JSON with channel types', () {
        final menu = SelectMenu.channel('channel_select',
            channelTypes: [ChannelType.guildText, ChannelType.guildVoice]);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.channelSelectMenu.value,
              'custom_id': 'channel_select',
              'placeholder': null,
              'disabled': null,
              'channel_types': [0, 2],
            }));
      });

      test('generates valid Discord API JSON with default values', () {
        final menu = SelectMenu.channel('channel_select',
            defaultValues: [Snowflake('111222333')]);

        expect(
            menu.toJson(),
            equals({
              'type': ComponentType.channelSelectMenu.value,
              'custom_id': 'channel_select',
              'placeholder': null,
              'disabled': null,
              'default_values': [
                {'id': '111222333', 'type': 'channel'},
              ],
            }));
      });
    });
  });

  group('SelectMenuOption', () {
    test('generates valid Discord API JSON', () {
      final option = SelectMenuOption(label: 'Red', value: 'red');

      expect(
          option.toJson(),
          equals({
            'label': 'Red',
            'value': 'red',
            'description': null,
            'default': false,
          }));
    });

    test('generates valid Discord API JSON with description', () {
      final option = SelectMenuOption(
          label: 'Red', value: 'red', description: 'A warm color');

      expect(
          option.toJson(),
          equals({
            'label': 'Red',
            'value': 'red',
            'description': 'A warm color',
            'default': false,
          }));
    });

    test('generates valid Discord API JSON with emoji', () {
      final option = SelectMenuOption(
          label: 'Fire', value: 'fire', emoji: PartialEmoji.fromUnicode('🔥'));

      expect(
          option.toJson(),
          equals({
            'label': 'Fire',
            'value': 'fire',
            'description': null,
            'emoji': {
              'name': '🔥',
              'id': null,
              'animated': false,
            },
            'default': false,
          }));
    });

    test('generates valid Discord API JSON with default true', () {
      final option =
          SelectMenuOption(label: 'Default', value: 'default', isDefault: true);

      expect(
          option.toJson(),
          equals({
            'label': 'Default',
            'value': 'default',
            'description': null,
            'default': true,
          }));
    });
  });
}
