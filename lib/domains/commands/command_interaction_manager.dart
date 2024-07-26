import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/api/common/commands/command_context_type.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/commands/command_builder.dart';
import 'package:mineral/domains/commands/command_interaction_dispatcher.dart';
import 'package:mineral/domains/types/interaction_dispatcher_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

abstract class CommandInteractionManagerContract {
  final List<(String, Function handler)> commandsHandler = [];
  final List<CommandBuilder> commands = [];
  late InteractionDispatcherContract dispatcher;

  Future<void> registerGlobal(Bot bot);

  Future<void> registerServer(Bot bot, Server server);

  void addCommand(CommandBuilder command);
}

final class CommandInteractionManager
    implements CommandInteractionManagerContract {
  @override
  final List<(String, Function handler)> commandsHandler = [];

  @override
  final List<CommandBuilder> commands = [];

  @override
  late InteractionDispatcherContract dispatcher;

  final MarshallerContract _marshaller;

  CommandInteractionManager(this._marshaller) {
    dispatcher = CommandInteractionDispatcher(this, _marshaller);
  }

  @override
  void addCommand(CommandBuilder command) {
    if (commands.contains(command)) {
      throw Exception('Command $command already exists');
    }

    final handlers = switch (command) {
      final CommandDeclarationBuilder command => command.reduceHandlers(command.name!),
      final CommandDefinitionBuilder definition =>
        definition.command.reduceHandlers(definition.command.name!),
      final _ => throw Exception('Unknown command type')
    };

    commands.add(command);
    commandsHandler.addAll(handlers);
  }

  @override
  Future<void> registerGlobal(Bot bot) async {
    final List<CommandBuilder> globalCommands =
        _getContext(CommandContextType.global);
    final payload = _serializeCommand(globalCommands);

    await _marshaller.dataStore.client
        .put('/applications/${bot.id}/commands', body: payload);
  }

  @override
  Future<void> registerServer(Bot bot, Server server) async {
    final List<CommandBuilder> guildCommands =
        _getContext(CommandContextType.guild);
    final payload = _serializeCommand(guildCommands);

    await _marshaller.dataStore.client.put(
        '/applications/${bot.id}/guilds/${server.id}/commands',
        body: payload);
  }

  List<CommandBuilder> _getContext(CommandContextType contextType) {
    return commands.where((command) {
      final context = switch (command) {
        final CommandDeclarationBuilder command => command.context,
        final CommandDefinitionBuilder definition => definition.command.context,
        final _ => throw Exception('Unknown command type')
      };

      return context == contextType;
    }).toList();
  }

  List<Map<String, dynamic>> _serializeCommand(List<CommandBuilder> commands) {
    return commands.map((command) {
      return switch (command) {
        final CommandDeclarationBuilder command => command.toJson(),
        final CommandDefinitionBuilder definition =>
          definition.command.toJson(),
        final _ => throw Exception('Unknown command type')
      };
    }).toList();
  }
}
