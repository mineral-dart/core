import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/commands/builder/command_builder.dart';
import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/builder/translation.dart';
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
            });

          final int currentGroupIndex = command.groups.indexOf(currentGroup);
          final int currentSubCommandIndex =
              currentGroup.commands.indexOf(currentGroup.commands.last);
          _commandMapper[element.key] =
              () => command.groups[currentGroupIndex].commands[currentSubCommandIndex];
        } else {
          command.addSubCommand((command) {
            return command
              ..setName(defaultName, translation: Translation({'name': nameTranslations}))
              ..setDescription(defaultDescription,
                  translation: Translation({'description': descriptionTranslations}));
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

  CommandDefinition overrideCommand<T>(String key, Function(T) fn) {
    final command = _commandMapper.entries.firstWhere((element) => element.key == key);
    command.value();

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
    final YamlMap yamlMap = loadYaml(stringContent);
    final content = yamlMap.toMap();

    _declareCommand(content);
    _declareGroups(content);
    _declareSubCommands(content);

    return this;
  }
}
