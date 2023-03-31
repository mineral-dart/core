import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/entities/command.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:mineral_contract/mineral_contract.dart';

class CommandService extends MineralService implements CommandServiceContract {
  final Map<String, CommandBuilder> _commands = {};
  Map<String, CommandBuilder> get commands => _commands;

  final Map<String, Function> _guildHandlers = {};
  final Map<String, Function> _globalHandlers = {};

  StreamController<CommandCreateEvent> controller = StreamController();

  CommandService(List<MineralCommandContract> commands): super(inject: true) {
    register(commands);

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

      final Scope scope = command.scope ?? Scope.guild;

      if(scope.isGuild) {
        Function function = _guildHandlers.getOrFail(identifier);
        await function(event.getInteraction<GuildCommandInteraction>(Scope.guild));
      } else {
        Function function = _globalHandlers.getOrFail(identifier);
        await function(event.getInteraction<GlobalCommandInteraction>(Scope.global));
      }
    });
  }

  @override
  void register (List<MineralCommandContract> commands) {
    for (final mineralCommand in List<MineralCommand>.from(commands)) {
      final command = mineralCommand.command;
      _commands.putIfAbsent(mineralCommand.command.label, () => mineralCommand.command);

      final Scope scope = command.scope ?? Scope.guild;
      if (command.subcommands.isEmpty && command.groups.isEmpty) {
        if(scope.isGuild) {
          _guildHandlers.putIfAbsent(command.label, () => mineralCommand.handle);
        } else {
          _globalHandlers.putIfAbsent(command.label, () => mineralCommand.handle);
        }
      }

      if (command.subcommands.isNotEmpty) {
        _registerSubCommands(mineralCommand.command.label, scope, command.subcommands);
      }

      if (command.groups.isNotEmpty) {
        for (final group in command.groups) {
          _registerSubCommands(mineralCommand.command.label + '.' + group.label, command.scope ?? Scope.guild, group.subcommands);
        }
      }

      _commands.putIfAbsent(mineralCommand.command.label, () => mineralCommand.command);
    }
  }

  void _registerSubCommands (String identifier, Scope scope, List<SubCommandBuilder> commands) {
    for (final subcommand in commands) {
      if(scope.isGlobal) {
        _globalHandlers.putIfAbsent(identifier + '.' + subcommand.label, () => subcommand.handle);
      } else {
        _guildHandlers.putIfAbsent(identifier + '.' + subcommand.label, () => subcommand.handle);
      }
    }
  }

  List<CommandBuilder> getGuildCommands (Guild guild) {
    return _commands.values.where((element) => element.scope?.mode == Scope.guild.mode || element.scope?.mode == guild.id).toList();
  }

  List<CommandBuilder> getGlobalCommands () {
    return _commands.values.where((element) => element.scope?.mode == Scope.global.mode).toList();
  }
}
