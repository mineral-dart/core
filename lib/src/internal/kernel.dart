import 'dart:io';

import 'package:mineral/exception.dart';
import 'package:mineral/src/commands/create_project.dart';
import 'package:mineral/src/commands/help.dart';
import 'package:mineral/src/commands/make_command.dart';
import 'package:mineral/src/commands/make_event.dart';
import 'package:mineral/src/commands/make_module.dart';
import 'package:mineral/src/commands/make_store.dart';
import 'package:mineral/src/commands/start_project.dart';
import 'package:mineral/src/internal/managers/intent_manager.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/module_manager.dart';
import 'package:mineral/src/internal/managers/plugin_manager.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:path/path.dart';

class Kernel {
  EventManager events = EventManager();
  CommandManager commands = CommandManager();
  StateManager states = StateManager();
  ModuleManager modules = ModuleManager();
  CliManager cli = CliManager();
  ContextMenuManager contextMenus = ContextMenuManager();
  IntentManager intents = IntentManager();
  PluginManager plugins = PluginManager();
  Environment environment = Environment();

  Kernel() {
    ioc.bind(namespace: Service.event, service: events);
    ioc.bind(namespace: Service.command, service: commands);
    ioc.bind(namespace: Service.store, service: states);
    ioc.bind(namespace: Service.modules, service: modules);
    ioc.bind(namespace: Service.cli, service: cli);
    ioc.bind(namespace: Service.contextMenu, service: contextMenus);
    ioc.bind(namespace: Service.environment, service: environment);
  }

  void loadConsole () {
    cli.add(MakeCommand());
    cli.add(MakeEvent());
    cli.add(MakeModule());
    cli.add(MakeStore());
    cli.add(CreateProject());
    cli.add(StartProject());
    cli.add(Help());
  }

  Future<void> init () async {
    await environment.load();

    Http http = Http(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    ioc.bind(namespace: Service.http, service: http);

    String? report = environment.get('REPORTER');
    if (report != null) {
      ReporterManager reporter = ReporterManager(Directory(join(Directory.current.path, 'logs')));
      reporter.reportLevel = report;

      ioc.bind(namespace: Service.reporter, service: reporter);
    }

    String? token = environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException(
        prefix: 'MISSING TOKEN',
        cause: 'APP_TOKEN is not defined in your environment'
      );
    }

    await modules.load(this);
    await plugins.load();

    final String? shardsCount = environment.get('SHARDS_COUNT');

    ShardManager manager = ShardManager(http, token, intents.list);
    manager.start(shardsCount: (shardsCount != null ? int.tryParse(shardsCount) : null));

    ioc.bind(namespace: Service.shards, service: manager);
  }
}
