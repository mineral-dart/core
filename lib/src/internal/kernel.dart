import 'dart:io';

import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/commands/compile/exe.dart';
import 'package:mineral/src/commands/compile/js.dart';
import 'package:mineral/src/commands/help.dart';
import 'package:mineral/src/commands/make/command.dart';
import 'package:mineral/src/commands/make/event.dart';
import 'package:mineral/src/commands/make/module.dart';
import 'package:mineral/src/commands/make/shared_state.dart';
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
import 'package:mineral/src/internal/themes/mineral_theme.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:path/path.dart';
import 'package:mineral_cli/mineral_cli.dart';

class Kernel with Container {
  final CollectorManager _collectors = CollectorManager();
  final EnvironmentManager _environment = EnvironmentManager();
  final EventManager events = EventManager();
  final CommandManager commands = CommandManager();
  final StateManager states = StateManager();
  final ModuleManager modules = ModuleManager();
  final MineralCliContract _cli = MineralCli(MineralTheme());
  final ContextMenuManager contextMenus = ContextMenuManager();
  final IntentManager intents = IntentManager();
  final PluginManagerCraft plugins = PluginManagerCraft();

  void loadConsole () {
    stdin.lineMode = true;
    final console  = Console(theme: DefaultTheme());

    _cli.register([
      MakeEvent(console),
      MakeCommand(console),
      MakeSharedState(console),
      MakeModule(console),
      CompileExecutable(console),
      CompileJavascript(console),
      Help(console, _cli),
    ]);
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

  void defineConsoleTheme (Theme theme) {
    _cli.defineConsoleTheme(theme);
  }
}
