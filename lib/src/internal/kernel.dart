import 'dart:io';

import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/commands/create_project.dart';
import 'package:mineral/src/commands/help.dart';
import 'package:mineral/src/commands/make_command.dart';
import 'package:mineral/src/commands/make_event.dart';
import 'package:mineral/src/commands/make_module.dart';
import 'package:mineral/src/commands/make_shared_state.dart';
import 'package:mineral/src/commands/start_project.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:mineral/src/internal/managers/collector_manager.dart';
import 'package:mineral/src/internal/managers/command_manager.dart';
import 'package:mineral/src/internal/managers/context_menu_manager.dart';
import 'package:mineral/src/internal/managers/environment_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/managers/intent_manager.dart';
import 'package:mineral/src/internal/managers/module_manager.dart';
import 'package:mineral/src/internal/managers/plugin_manager.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral/src/internal/managers/state_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:path/path.dart';

class Kernel with Container {
  final CollectorManager _collectors = CollectorManager();
  final EnvironmentManager _environment = EnvironmentManager();
  EventManager events = EventManager();
  CommandManager commands = CommandManager();
  StateManager states = StateManager();
  ModuleManager modules = ModuleManager();
  CliManager cli = CliManager();
  ContextMenuManager contextMenus = ContextMenuManager();
  IntentManager intents = IntentManager();
  PluginManagerCraft plugins = PluginManagerCraft();

  void loadConsole () {
    cli.add(MakeCommand());
    cli.add(MakeEvent());
    cli.add(MakeModule());
    cli.add(MakeSharedState());
    cli.add(CreateProject());
    cli.add(StartProject());
    cli.add(Help());
  }

  Future<void> init () async {
    await _environment.load();

    Http http = Http(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    container.bind((_) => http);

    String? report = _environment.environment.get('REPORTER');
    if (report != null) {
      ReporterManager reporter = ReporterManager(Directory(join(Directory.current.path, 'logs')));
      reporter.reportLevel = report;

      container.bind((_) => reporter);
    }

    String? token = _environment.environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException(
        prefix: 'MISSING TOKEN',
        cause: 'APP_TOKEN is not defined in your environment'
      );
    }

    await modules.load(this);
    await plugins.load();

    final String? shardsCount = _environment.environment.get('SHARDS_COUNT');

    ShardManager shardManager = ShardManager(http, token, intents.list);
    shardManager.start(shardsCount: (shardsCount != null ? int.tryParse(shardsCount) : null));
  }
}
