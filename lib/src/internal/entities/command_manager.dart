import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

enum ApplicationCommandType {
  chatInput(1),
  user(2),
  message(3);

  final int value;
  const ApplicationCommandType(this.value);
}

class CommandManager {
  final Collection<String, MineralCommand> _commands = Collection();

  CommandManager add (Object object) {
    dynamic decorator = reflect(object).type.metadata.first.reflectee;

    MineralCommand command = MineralCommand(
      name: decorator.name,
      description: decorator.description,
      scope: decorator.scope,
    );

    _commands.set<MineralCommand>(decorator.name, command);
    return this;
  }

  List<MineralCommand> getFromGuild (Guild guild) {
    List<MineralCommand> commands = [];
    _commands.forEach((name, command) {
      if (command.scope == guild.id || command.scope == 'GUILD') {
        commands.add(command);
      }
    });

    return commands;
  }

  List<MineralCommand> getGlobals () {
    List<MineralCommand> commands = [];
    _commands.forEach((name, command) {
      if (command.scope == 'GLOBAL') {
        commands.add(command);
      }
    });

    return commands;
  }
}

class Command {
  final String type = 'command';
  final String name;
  final String description;
  final String scope;

  const Command ({ required this.name, required this.description, required this.scope });
}

class MineralCommand {
  String name;
  String description;
  String scope;

  MineralCommand({ required this.name, required this.description, required this.scope });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': ApplicationCommandType.chatInput.value,
    };
  }
}
