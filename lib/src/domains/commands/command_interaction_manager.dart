import 'dart:async';

import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/bot/bot.dart';
import 'package:mineral/src/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/src/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/src/api/common/commands/command_context_type.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/commands/command_builder.dart';
import 'package:mineral/src/domains/commands/command_interaction_dispatcher.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_property_exception.dart';
import 'package:mineral/src/infrastructure/services/http/request.dart';

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

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  CommandInteractionManager() {
    dispatcher = CommandInteractionDispatcher(this);
  }

  @override
  void addCommand(CommandBuilder command) {
    if (commands.contains(command)) {
      throw Exception('Command $command already exists');
    }

    final name = switch (command) {
      final CommandDeclarationBuilder command => command.name,
      final CommandDefinitionBuilder definition => definition.command.name,
      final _ => throw Exception('Unknown command type')
    };

    if (name == null) {
      throw MissingPropertyException('Command name is required');
    }

    final handlers = switch (command) {
      final CommandDeclarationBuilder command =>
        command.reduceHandlers(command.name!),
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

    final req = Request.json(
        endpoint: '/applications/${bot.id}/commands', body: payload);
    await _dataStore.client.put(req);
  }

  @override
  Future<void> registerServer(Bot bot, Server server) async {
    final List<CommandBuilder> guildCommands =
        _getContext(CommandContextType.server);
    final payload = _serializeCommand(guildCommands);

    final req = Request.json(
        endpoint: '/applications/${bot.id}/guilds/${server.id}/commands',
        body: payload);

    final response = await _dataStore.client.put(req);
    if (response.statusCode == 400) {
      final error = Map<String, dynamic>.from(response.body['errors'])
          .values
          .firstOrNull?['name'];

      final errors = List.from(error?['_errors'] ?? []).firstOrNull;

      throw Exception('${errors['code']}: ${errors['message']}');
    }
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
