import 'dart:io';

import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/commands/compile/exe.dart';
import 'package:mineral/src/commands/compile/js.dart';
import 'package:mineral/src/commands/help.dart';
import 'package:mineral/src/commands/make/command.dart';
import 'package:mineral/src/commands/make/event.dart';
import 'package:mineral/src/commands/make/module.dart';
import 'package:mineral/src/commands/make/service.dart';
import 'package:mineral/src/commands/make/shared_state.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';
import 'package:mineral/src/internal/services/discord_api_http_service.dart';
import 'package:mineral/src/internal/services/environment_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/services/intent_service.dart';
import 'package:mineral/src/internal/services/package_service.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';
import 'package:mineral/src/internal/themes/mineral_theme.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_console/mineral_console.dart';

class Kernel with Container {
  final IntentService intents;

  final EnvironmentService _environment = EnvironmentService();
  final MineralCliContract cli = MineralCli(MineralTheme());

  late EventService events;
  late CommandService commands;
  late SharedStateService states;
  late ContextMenuService contextMenus;
  late PackageService packages;

  Kernel ({
    required this.intents,
    EventService? events,
    CommandService? commands,
    SharedStateService? states,
    PackageService? packages,
    ContextMenuService? contextMenus,
  }) {
    this.states = states ?? SharedStateService([]);
    this.commands = commands ?? CommandService([]);
    this.contextMenus = contextMenus ?? ContextMenuService([]);
    this.events = events ?? EventService([]);
    this.packages = packages ?? PackageService([]);

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
      MakeService(console),
      CompileExecutable(console),
      CompileJavascript(console),
      Help(console, cli),
    ]);
  }

  Future<void> init () async {
    await _environment.load();

    final DiscordApiHttpService http = DiscordApiHttpService('https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    container.bind((_) => http);

    String? token = _environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException('APP_TOKEN is not defined in your environment');
    }

    await packages.load();

    final String? shardsCount = _environment.get('SHARDS_COUNT');

    ShardManager shardManager = ShardManager(http, token, intents.list);
    shardManager.start(shardsCount: (shardsCount != null ? int.tryParse(shardsCount) : null));
  }

  void defineConsoleTheme (Theme theme) {
    cli.defineConsoleTheme(theme);
  }
}
