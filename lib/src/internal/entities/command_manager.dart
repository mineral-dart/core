import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class CommandManager {
  final Collection<String, MineralCommand> commands = Collection();
  final Map<String, dynamic> handlers = {};

  CommandManager add (Object object) {
    MineralCommand command = MineralCommand(name: '', description: '', scope: '', options: []);

    _registerCommands(
      command: command,
      object: object
    );

    _registerCommandMethods(
      command: command,
      object: object
    );

    commands.set<MineralCommand>(command.name, command);
    return this;
  }

  List<MineralCommand> getFromGuild (Guild guild) {
    List<MineralCommand> commands = [];
    this.commands.forEach((name, command) {
      if (command.scope == guild.id || command.scope == 'GUILD') {
        commands.add(command);
      }
    });

    return commands;
  }

  List<MineralCommand> getGlobals () {
    List<MineralCommand> commands = [];
    this.commands.forEach((name, command) {
      if (command.scope == 'GLOBAL') {
        commands.add(command);
      }
    });

    return commands;
  }

  void _registerCommands ({ required MineralCommand command, required Object object }) {
    ClassMirror classMirror = reflect(object).type;
    dynamic classCommand = reflect(object).reflectee;

    for (InstanceMirror element in classMirror.metadata) {
      dynamic reflectee = element.reflectee;

      if (reflectee is CommandGroup) {
        MineralCommand group = MineralCommand(name: '', description: '', scope: '', options: [])
          ..type = 2
          ..name = reflectee.name
          ..description = reflectee.description;

        command.groups.add(group);
      }

      if (reflectee is Command) {
        command
          ..name = reflectee.name
          ..description = reflectee.description
          ..scope = reflectee.scope;

        if (classMirror.instanceMembers.values.toList().where((element) => element.simpleName == Symbol('handle')).isNotEmpty) {
          MethodMirror handle = classMirror.instanceMembers.values.toList().firstWhere((element) => element.simpleName == Symbol('handle'));
          handlers.putIfAbsent(command.name, () => {
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

  void _registerCommandMethods ({ required MineralCommand command, required Object object }) {
    dynamic classCommand = reflect(object).reflectee;
    reflect(object).type.declarations.forEach((key, value) {
      if (value.metadata.isEmpty) {
        return;
      }

      MineralCommand subcommand = MineralCommand(name: '', description: '', scope: '', options: []);
      subcommand.name = value.metadata.first.reflectee.name;
      subcommand.description = value.metadata.first.reflectee.description;

      for (InstanceMirror metadata in value.metadata) {
        dynamic reflectee = metadata.reflectee;

        if (reflectee is Subcommand) {
          String? groupName = reflectee.group;

          if (groupName != null) {
            MineralCommand group = command.groups.firstWhere((group) => group.name == groupName);
            group.subcommands.add(subcommand);

            handlers.putIfAbsent("${command.name}.${group.name}.${subcommand.name}", () => {
              'symbol': Symbol(subcommand.name),
              'commandClass': classCommand,
            });
          } else {
            command.subcommands.add(subcommand);
            handlers.putIfAbsent("${command.name}.${subcommand.name}", () => {
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

class Command {
  final String type = 'command';
  final String name;
  final String description;
  final String scope;

  const Command ({ required this.name, required this.description, required this.scope });
}

class CommandGroup {
  final String name;
  final String description;
  final int type = 2;

  const CommandGroup ({ required this.name, required this.description });
}

class Subcommand {
  final String name;
  final String description;
  final int type = 1;
  final String? group;

  const Subcommand ({ required this.name, required this.description, this.group });
}


enum OptionType {
  string(3),
  integer(4),
  boolean(5),
  user(6),
  channel(7),
  role(8),
  mentionable(9),
  number(10),
  attachment(11);

  final int value;
  const OptionType(this.value);
}

class OptionChoice {
  final String label;
  final String value;

  const OptionChoice({ required this.label, required this.value });

  Object toJson () => { 'name': label, 'value': value };
}

class Option {
  final String name;
  final String description;
  final OptionType type;
  final bool required;
  final List<ChannelType>? channels;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;

  const Option ({
    required this.name,
    required this.description,
    required this.type,
    required this.required,
    this.channels,
    this.min,
    this.max,
    this.choices,
  });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': required,
      'channel_types': channels?.map((channel) => channel.value).toList(),
      'choices': choices?.map((choice) => choice.toJson()).toList(),
      'min_value': min,
      'max_value': max,
    };
  }
}

class MineralCommand {
  String name;
  String description;
  String scope;
  int type = 1;
  List<Option> options = [];
  List<MineralCommand> groups = [];
  List<MineralCommand> subcommands = [];

  MineralCommand({ required this.name, required this.description, required this.scope, required this.options });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type,
      'options': groups.isNotEmpty
         ? [...groups.map((group) => group.toJson()).toList(), ...subcommands.map((subcommand) => subcommand.toJson()).toList()]
         : subcommands.isNotEmpty
            ? subcommands.map((subcommand) => subcommand.toJson()).toList()
            : options.map((option) => option.toJson()).toList(),
    };
  }
}
