import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

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

class MineralCommand {
  late MineralClient client;
  late StoreManager stores;
  late Environment environment;
}

class Command {
  final String type = 'command';
  final String name;
  final String description;
  final String scope;
  final bool? everyone;
  final bool? dmChannel;

  const Command ({ required this.name, required this.description, required this.scope, this.everyone, this.dmChannel });
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
  final bool? required;
  final List<ChannelType>? channels;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;

  const Option ({
    required this.name,
    required this.description,
    required this.type,
    this.required,
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
      'required': required ?? false,
      'channel_types': channels?.map((channel) => channel.value).toList(),
      'choices': choices?.map((choice) => choice.toJson()).toList(),
      'min_value': min,
      'max_value': max,
    };
  }
}

class SlashCommand {
  String name;
  String description;
  String scope;
  bool everyone;
  bool dmChannel;
  int type = 1;
  List<Option> options = [];
  List<SlashCommand> groups = [];
  List<SlashCommand> subcommands = [];

  SlashCommand({ required this.name, required this.description, required this.scope, required this.everyone, required this.dmChannel, required this.options });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type,
      'default_member_permissions': !everyone ? '0' : null,
      'dm_permission': dmChannel,
      'options': groups.isNotEmpty
         ? [...groups.map((group) => group.toJson()).toList(), ...subcommands.map((subcommand) => subcommand.toJson()).toList()]
         : subcommands.isNotEmpty
            ? subcommands.map((subcommand) => subcommand.toJson()).toList()
            : options.map((option) => option.toJson()).toList(),
    };
  }
}
