import 'package:mineral/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/commands/make_command.dart';
import 'package:mineral/src/internal/entities/cli_manager.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/module_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';

import 'entities/store_manager.dart';

class Kernel {
  EventManager events = EventManager();
  CommandManager commands = CommandManager();
  StoreManager stores = StoreManager();
  ModuleManager modules = ModuleManager();
  CliManager cli = CliManager();
  List<Intent> intents = [];

  Kernel() {
    ioc.bind(namespace: ioc.services.event, service: events);
    ioc.bind(namespace: ioc.services.command, service: commands);
    ioc.bind(namespace: ioc.services.store, service: stores);
    ioc.bind(namespace: ioc.services.modules, service: modules);
    ioc.bind(namespace: ioc.services.cli, service: cli);

    cli.add(MakeCommand());
  }

  Future<void> init () async {
    Environment environment = await _loadEnvironment();

    Http http = Http(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    ioc.bind(namespace: ioc.services.http, service: http);

    String? token = environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException(
        prefix: 'MISSING TOKEN',
        cause: 'APP_TOKEN is not defined in your environment'
      );
    }

    await modules.load();

    final String? shardsCount = environment.get('SHARDS_COUNT');

    ShardManager manager = ShardManager(http, token, intents);
    manager.start(shardsCount: (shardsCount != null ? int.tryParse(shardsCount) : null));

    ioc.bind(namespace: ioc.services.shards, service: manager);
  }


  Future<Environment> _loadEnvironment () async {
    Environment environment = Environment();
    ioc.bind(namespace: ioc.services.environment, service: environment);

    return await environment.load('.env');
  }
}
