import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/common/commands/builder/command_builder.dart';
import 'package:mineral/api/common/commands/command_context_type.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/interaction/interaction_dispatcher.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';

abstract class InteractionManagerContract {
  final List<(String, Function handler)> commandsHandler = [];
  final List<CommandBuilder> commands = [];
  late InteractionDispatcherContract dispatcher;

  Future<void> registerGlobal(Bot bot);
  Future<void> registerServer(Bot bot, Server server);
  void addCommand(CommandBuilder command);
}

final class InteractionManager implements InteractionManagerContract {
  @override
  final List<(String, Function handler)> commandsHandler = [];

  @override
  final List<CommandBuilder> commands = [];

  @override
  late InteractionDispatcherContract dispatcher;

  final DataStoreContract _dataStore;

  InteractionManager(this._dataStore) {
    dispatcher = InteractionDispatcher(this);
  }

  @override
  void addCommand(CommandBuilder command) {
    if (commands.contains(command)) {
      throw Exception('Command $command already exists');
    }

    commands.add(command);
    commandsHandler.addAll(command.reduceHandlers());
  }

  @override
  Future<void> registerGlobal(Bot bot) async {
    final List<CommandBuilder> globalCommands = commands.where((command) => command.context == CommandContextType.global).toList();

    await _dataStore.client.put('/applications/${bot.id}/commands', body: [
      ...globalCommands.map((e) => e.toJson())
    ]);
  }

  @override
  Future<void> registerServer(Bot bot, Server server) async {
    final List<CommandBuilder> guildCommands = commands.where((command) => command.context == CommandContextType.guild).toList();

    await _dataStore.client.put('/applications/${bot.id}/guilds/${server.id}/commands', body: [
      ...guildCommands.map((e) => e.toJson())
    ]);
  }

  factory InteractionManager.singleton() {
    return ioc.resolve('interactionManager');
  }
}