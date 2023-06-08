import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

class CommandService extends MineralService implements CommandServiceContract {
  final Map<String, AbstractCommand> _commands = {};
  final Map<String, AbstractCommand> _handlers = {};

  Map<String, AbstractCommand> get commands => _commands;

  StreamController<CommandCreateEvent> controller = StreamController();

  CommandService(List<MineralCommandContract> commands): super(inject: true) {
    register(commands);

    controller.stream.listen((event) async {
      final command = _handlers.getOrFail(_buildIdentifier(event.interaction.data));

      await command.handle(command.scope!.isGlobal
          ? event.getInteraction<GlobalCommandInteraction>(CommandScope.global)
          : event.getInteraction<GuildCommandInteraction>(CommandScope.guild));
    });
  }

  @override
  void register (List<MineralCommandContract> commands) {
    for (final command in List<MineralCommand>.from(commands)) {
      _commands.putIfAbsent(command.label, () => command);

      if (command.subcommands.isNotEmpty) {
        _registerSubCommands(command.label, command.scope ?? CommandScope.guild, command.subcommands, null);
      }

      if (command.groups.isNotEmpty) {
        for (final group in command.groups) {
          _registerSubCommands(command.label, command.scope ?? CommandScope.guild, group.subcommands, group);
        }
      }
    }
  }

  void _registerSubCommands (String identifier, CommandScope scope, List<MineralSubcommand> commands, MineralCommandGroup? group) {
    for (final subcommand in commands) {
      final location = join(identifier, group?.label, subcommand.label)
          .replaceAll(separator, '.');

      _handlers.putIfAbsent(location, () => subcommand);
    }
  }

  String _buildIdentifier (Map<String, dynamic> payload) {
    if (payload['type'] == CommandType.subcommand.type && payload['id'] == null) {
      return payload['name'];
    }

    return payload['name'] += '.' + _buildIdentifier(payload['options'][0]);
  }

  List<AbstractCommand> getGuildCommands (Guild guild) {
    return List<AbstractCommand>.from(_commands.values.where((element) => element.scope?.mode == CommandScope.guild.mode || element.scope?.mode == guild.id));
  }

  List<AbstractCommand> getGlobalCommands () {
    return List<AbstractCommand>.from(_commands.values.where((element) => element.scope?.mode == CommandScope.global.mode));
  }
}