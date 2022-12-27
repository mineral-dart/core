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
import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/managers/environment_service.dart';
import 'package:mineral/src/internal/managers/intent_manager.dart';
import 'package:mineral/src/internal/services/plugin_service.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/services/module_service.dart';
import 'package:mineral/src/internal/themes/mineral_theme.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_console/mineral_console.dart';

class Kernel with Container {
  final EnvironmentService _environment = EnvironmentService();
  final EventService events = EventService();
  final CommandService commands = CommandService();
  final SharedStateService states = SharedStateService();
  final ModuleService modules = ModuleService();
  final MineralCliContract cli = MineralCli(MineralTheme());
  final ContextMenuService contextMenus = ContextMenuService();
  final IntentManager intents = IntentManager();
  final PluginServiceCraft plugins = PluginServiceCraft();

  Kernel () {
    CollectorService();
    DebuggerService('[ debug ]');
  }

  void loadConsole () {
    stdin.lineMode = true;
    final console = Console(theme: DefaultTheme());

    cli.register([
      MakeEvent(console),
      MakeCommand(console),
      MakeSharedState(console),
      MakeModule(console),
      CompileExecutable(console),
      CompileJavascript(console),
      Help(console, cli),
    ]);
  }

  Future<void> init () async {
    await _environment.load();

    final HttpService http = HttpService(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    container.bind((_) => http);

    String? token = _environment.environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException('APP_TOKEN is not defined in your environment');
    }

    await modules.load(this);
    await plugins.load();

    final String? shardsCount = _environment.environment.get('SHARDS_COUNT');

    ShardManager shardManager = ShardManager(http, token, intents.list);
    shardManager.start(shardsCount: (shardsCount != null ? int.tryParse(shardsCount) : null));
  }

  void defineConsoleTheme (Theme theme) {
    cli.defineConsoleTheme(theme);
  }
}
