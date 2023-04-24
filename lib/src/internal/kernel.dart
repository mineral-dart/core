import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/collector_service.dart';
import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral/src/internal/services/console/themes/console_theme.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';
import 'package:mineral/src/internal/services/discord_api_http_service.dart';
import 'package:mineral/src/internal/services/environment_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/services/intent_service.dart';
import 'package:mineral/src/internal/services/package_service.dart';
import 'package:mineral/src/internal/services/shared_state_service.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';

class Kernel with Container {
  final IntentService intents;

  final EnvironmentService _environment = EnvironmentService();
  final ConsoleService _console = ConsoleService(theme: ConsoleTheme());
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

  Future<void> init () async {
    container.bind((_) => _console);
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
}
