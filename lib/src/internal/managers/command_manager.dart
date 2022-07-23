import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/src/internal/entities/command.dart';

class CommandManager {
  final Map<String, SlashCommand> _commands = {};
  final Map<String, dynamic> _handlers = {};

  Map<String, SlashCommand> getRegisteredCommands () => _commands;

  Map<String, dynamic> getHandlers () => _handlers;

  dynamic getHandler (String handler) => _handlers[handler];

  CommandManager add (MineralCommand mineralCommand) {
    SlashCommand command = SlashCommand(name: '', description: '', scope: '', everyone: true, dmChannel: false, options: []);

    _registerCommands(
      command: command,
      mineralCommand: mineralCommand
    );

    _registerCommandMethods(
      command: command,
      mineralCommand: mineralCommand
    );

    _commands.set(command.name, command);
    return this;
  }

  List<SlashCommand> getFromGuild (Guild guild) {
    List<SlashCommand> commands = [];
    _commands.forEach((name, command) {
      if (command.scope == guild.id || command.scope == 'GUILD') {
        commands.add(command);
      }
    });

    return commands;
  }

  List<SlashCommand> getGlobals () {
    List<SlashCommand> commands = [];
    _commands.forEach((name, command) {
      if (command.scope == 'GLOBAL') {
        commands.add(command);
      }
    });

    return commands;
  }

  void _registerCommands ({ required SlashCommand command, required MineralCommand mineralCommand }) {
    ClassMirror classMirror = reflect(mineralCommand).type;
    MineralCommand classCommand = reflect(mineralCommand).reflectee;

    for (InstanceMirror element in classMirror.metadata) {
      dynamic reflectee = element.reflectee;

      if (reflectee is CommandGroup) {
        SlashCommand group = SlashCommand(name: '', description: '', scope: '', everyone: true, dmChannel: false, options: [])
          ..type = 2
          ..name = reflectee.name.toLowerCase()
          ..description = reflectee.description;

        command.groups.add(group);
      }

      if (reflectee is Command) {
        command
          ..name = reflectee.name.toLowerCase()
          ..description = reflectee.description
          ..scope = reflectee.scope
          ..everyone = reflectee.everyone ?? false;

        if (classMirror.instanceMembers.values.toList().where((element) => element.simpleName == Symbol('handle')).isNotEmpty) {
          MethodMirror handle = classMirror.instanceMembers.values.toList().firstWhere((element) => element.simpleName == Symbol('handle'));
          _handlers.putIfAbsent(command.name, () => {
            'symbol': handle.simpleName,
            'commandClass': classCommand,
          });
        }
      }

      if (reflectee is Option) {
        command.options.add(reflectee);
      }
    }
  }

  void _registerCommandMethods ({ required SlashCommand command, required MineralCommand mineralCommand }) {
    dynamic classCommand = reflect(mineralCommand).reflectee;
    reflect(mineralCommand).type.declarations.forEach((key, value) {
      if (value.metadata.isEmpty) {
        return;
      }

      SlashCommand subcommand = SlashCommand(name: '', description: '', scope: '', everyone: true, dmChannel: false, options: []);
      subcommand.name = value.metadata.first.reflectee.name;
      subcommand.description = value.metadata.first.reflectee.description;

      for (InstanceMirror metadata in value.metadata) {
        dynamic reflectee = metadata.reflectee;

        if (reflectee is Subcommand) {
          String? groupName = reflectee.group;

          if (groupName != null) {
            SlashCommand group = command.groups.firstWhere((group) => group.name == groupName);
            group.subcommands.add(subcommand);

            _handlers.putIfAbsent("${command.name}.${group.name}.${subcommand.name}", () => {
              'symbol': Symbol(subcommand.name),
              'commandClass': classCommand,
            });
          } else {
            command.subcommands.add(subcommand);
            _handlers.putIfAbsent("${command.name}.${subcommand.name}", () => {
              'symbol': Symbol(subcommand.name),
              'commandClass': classCommand,
            });
          }

        }

        if (reflectee is Option) {
          subcommand.options.add(metadata.reflectee);
        }
      }
    });
  }
}
