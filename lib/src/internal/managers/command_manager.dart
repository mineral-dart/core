import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/entities/command.dart';

class CommandManager {
  final Map<String, CommandBuilder> _commands = {};
  Map<String, CommandBuilder> get commands => _commands;

  final Map<String, Function> _handlers = {};

  StreamController<CommandCreateEvent> controller = StreamController();

  CommandManager() {
    controller.stream.listen((event) async {
      final commandIdentifier = event.interaction.identifier;
      final command = _commands.get(commandIdentifier);

      if (command == null) {
        return;
      }

      String identifier = event.interaction.data['name'];

      void test (List<dynamic> options) {
        for (final option in options) {
          if (option['type'] == CommandType.group.type) {
            identifier += '.' + option['name'];
            test(option['options']);
          } else if (option['type'] == CommandType.subcommand.type) {
            identifier += '.' + option['name'];
          }
        }
      }

      final option = event.interaction.data['options']?[0];

      if (option?['options'] != null) {
        test(event.interaction.data['options']);
      }

      Function function = _handlers.getOrFail(identifier);
      await function(event.interaction);
    });
  }

  void register (List<MineralCommand> mineralCommands) {
    for (final mineralCommand in mineralCommands) {
      final command = mineralCommand.command;
      _commands.putIfAbsent(mineralCommand.command.label, () => mineralCommand.command);

      if (command.subcommands.isEmpty && command.groups.isEmpty) {
        _handlers.putIfAbsent(command.label, () => mineralCommand.handle);
      }

      if (command.subcommands.isNotEmpty) {
        _registerSubCommands(mineralCommand.command.label, command.subcommands);
      }

      if (command.groups.isNotEmpty) {
        for (final group in command.groups) {
          _registerSubCommands(mineralCommand.command.label + '.' + group.label, group.subcommands);
        }
      }

      _commands.putIfAbsent(mineralCommand.command.label, () => mineralCommand.command);
    }
  }

  void _registerSubCommands (String identifier, List<SubCommandBuilder> commands) {
    for (final subcommand in commands) {
      _handlers.putIfAbsent(identifier + '.' + subcommand.label, () => subcommand.handle);
    }
  }

  getGuildCommands (Guild guild) {
    return _commands.values.where((element) => element.scope?.mode == Scope.guild.mode || element.scope?.mode == guild.id).toList();
  }
}
