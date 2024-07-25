import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/commands/builder/command_builder.dart';
import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/builder/translation.dart';
import 'package:mineral/api/common/commands/command_choice_option.dart';
import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/lang.dart';
import 'package:yaml/yaml.dart';

final class CommandDefinition {
  final String _defaultIdentifier = '_default';

  final Map<String, dynamic Function()> _commandMapper = {};
  final CommandBuilder command = CommandBuilder();

  String _extractDefaultValue(String commandKey, String key, Map<String, dynamic> payload) {
    final Map<String, dynamic>? elements = payload[key];
    if (elements == null) {
      throw Exception('Missing "$key" key under $commandKey');
    }

    if (elements[_defaultIdentifier] case final String value) {
      return value;
    }

    throw Exception('Missing "$key.$_defaultIdentifier" key under $commandKey struct');
  }

  Map<Lang, String> _extractTranslations(String key, Map<String, dynamic> payload) {
    final Map<String, dynamic>? elements = payload[key];
    if (elements == null) {
      throw Exception('Missing "$key" key');
    }

    return elements.entries.whereNot((element) => element.key == _defaultIdentifier).fold({},
        (acc, element) {
      final lang = Lang.values.firstWhere((lang) => lang.uid == element.key);
      return {...acc, lang: element.value};
    });
  }

  void _declareGroups(Map<String, dynamic> content) {
    final Map<String, dynamic> groupList = content['groups'] ?? {};

    for (final element in groupList.entries) {
      final String defaultName = _extractDefaultValue(element.key, 'name', element.value);
      final String defaultDescription =
          _extractDefaultValue(element.key, 'description', element.value);

      final nameTranslations = _extractTranslations('name', element.value);
      final descriptionTranslations = _extractTranslations('description', element.value);

      command.createGroup((group) {
        return group
          ..setName(defaultName, translation: Translation({'name': nameTranslations}))
          ..setDescription(defaultDescription,
              translation: Translation({'name': descriptionTranslations}));
      });
    }
  }

  void _declareOptions(SubCommandBuilder command, MapEntry<String, dynamic> element) {
    final options = element.value['options'] ?? [];
    print([element.key, element.value]);
    for (final Map<String, dynamic> element in options) {
      final String name = _extractDefaultValue('option', 'name', element);
      final String description = _extractDefaultValue('option', 'description', element);
      final bool required = element['required'] ?? false;

      final option = switch (element['type']) {
        final String value when value == 'string' =>
          Option.string(name: name, description: description, required: required),
        final String value when value == 'integer' =>
          Option.integer(name: name, description: description, required: required),
        final String value when value == 'double' =>
          Option.double(name: name, description: description, required: required),
        final String value when value == 'string' =>
          Option.boolean(name: name, description: description, required: required),
        final String value when value == 'user' =>
          Option.user(name: name, description: description, required: required),
        final String value when value == 'channel' =>
          Option.channel(name: name, description: description, required: required),
        final String value when value == 'role' =>
          Option.role(name: name, description: description, required: required),
        final String value when value == 'mention' =>
          Option.mentionable(name: name, description: description, required: required),
        final String value when value == 'choice.string' => ChoiceOption.string(
            name: name,
            description: description,
            required: required,
            choices: List.from(element['choices'] ?? [])
                .map((element) => Choice<String>(element['name'], element['value']))
                .toList()),
        final String value when value == 'choice.integer' => ChoiceOption.integer(
            name: name,
            description: description,
            required: required,
            choices: List.from(element['choices'] ?? [])
                .map((element) => Choice(element['name'], int.parse(element['value'])))
                .toList()),
        final String value when value == 'choice.double' => ChoiceOption.double(
            name: name,
            description: description,
            required: required,
            choices: List.from(element['choices'] ?? [])
                .map((element) => Choice(element['name'], double.parse(element['value'])))
                .toList()),
        _ => throw Exception('Unknown option type')
      };

      command.addOption(option);
    }
  }

  void _declareSubCommands(Map<String, dynamic> content) {
    final Map<String, dynamic> commandList = content['commands'] ?? {};

    for (final element in commandList.entries) {
      if (element.key.contains('.')) {
        final String defaultName = _extractDefaultValue(element.key, 'name', element.value);
        final String defaultDescription =
            _extractDefaultValue(element.key, 'description', element.value);

        final nameTranslations = _extractTranslations('name', element.value);
        final descriptionTranslations = _extractTranslations('description', element.value);

        if (element.value['group'] case final String group) {
          final currentGroup = command.groups.firstWhere((element) => element.name == group)
            ..addSubCommand((command) {
              command
                ..setName(defaultName, translation: Translation({'name': nameTranslations}))
                ..setDescription(defaultDescription,
                    translation: Translation({'description': descriptionTranslations}));

              _declareOptions(command, element);
            });

          final int currentGroupIndex = command.groups.indexOf(currentGroup);
          final int currentSubCommandIndex =
              currentGroup.commands.indexOf(currentGroup.commands.last);
          _commandMapper[element.key] =
              () => command.groups[currentGroupIndex].commands[currentSubCommandIndex];
        } else {
          command.addSubCommand((command) {
            command
              ..setName(defaultName, translation: Translation({'name': nameTranslations}))
              ..setDescription(defaultDescription,
                  translation: Translation({'description': descriptionTranslations}));

            _declareOptions(command, element);
          });
          final currentSubCommandIndex = command.subCommands.indexOf(command.subCommands.last);
          _commandMapper[element.key] = () => command.subCommands[currentSubCommandIndex];
        }
      }
    }
  }

  void _declareCommand(Map<String, dynamic> content) {
    final Map<String, dynamic> commandList = content['commands'] ?? {};

    for (final element in commandList.entries) {
      if (!element.key.contains('.')) {
        final String defaultName = _extractDefaultValue(element.key, 'name', element.value);
        final String defaultDescription =
            _extractDefaultValue(element.key, 'description', element.value);

        final nameTranslations = _extractTranslations('name', element.value);
        final descriptionTranslations = _extractTranslations('description', element.value);

        command
          ..setName(defaultName, translation: Translation({'name': nameTranslations}))
          ..setDescription(defaultDescription,
              translation: Translation({'description': descriptionTranslations}));

        _commandMapper[element.key] = () => command;
      }
    }
  }

  CommandDefinition context<T>(String key, Function(T) fn) {
    final command = _commandMapper.entries.firstWhere((element) => element.key == key);
    fn(command.value());

    return this;
  }

  CommandDefinition setHandler(String key, Function fn) {
    final command = _commandMapper.entries.firstWhere((element) => element.key == key);

    switch (command.value()) {
      case final SubCommandBuilder command:
        command.setHandle(fn);
      case final CommandBuilder command:
        command.setHandle(fn);
    }

    return this;
  }

  CommandDefinition using(File file) {
    final String stringContent = file.readAsStringSync();
    final content = switch (file.path) {
      final String path when path.contains('.json') => jsonDecode(stringContent),
      final String path when path.contains('.yaml') => (loadYaml(stringContent) as YamlMap).toMap(),
      _ => throw Exception('File type not supported')
    };

    _declareCommand(content);
    _declareGroups(content);
    _declareSubCommands(content);

    return this;
  }
}
