import 'dart:io';
import 'dart:isolate';

import 'package:mineral/commands/generate_environment_command.dart';
import 'package:mineral/commands/help_command.dart';
import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/console_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/console/console.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/embedded/embedded_application.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/internal/watcher/hmr.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';
import 'package:path/path.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  late final LoggerContract logger;
  late final Console console;
  late final DiscordHttpClient http;

  late final String token;
  late final Intents intents;
  late final bool useHmr;

  late final WebsocketManager websocketManager;
  late final EmbeddedApplication application;

  Kernel._application(ApplicationConfigContract Function(Environment) app, LoggerContract Function() logger, HttpConfigContract Function(Environment) http) {
    _registerApplication(app);
    _registerLogger(logger);
    _registerHttp(http);

    application = EmbeddedApplication(this.logger);

    if (Isolate.current.debugName != application.isolateDebugName) {
      websocketManager = WebsocketManager(
        application: application,
        http: this.http,
        token: token,
        intents: intents
      );

      _createHmr(reloadable: useHmr);
      websocketManager.start(shardCount: 1);

      application.createAndListen();
    }
  }

  Kernel._console(LoggerContract Function() logger, ConsoleConfigContract Function() console) {
    _registerLogger(logger);
    _registerConsole(console);
  }

  Future<void> start () async {
  }

  /// Register the application
  void _registerApplication (ApplicationConfigContract Function(Environment) app) {
    final application = app(environment);

    token = application.token;
    intents = application.intents;
    useHmr = application.hmr;
  }

  /// Register the logger
  void _registerLogger(LoggerContract Function() logger) {
    this.logger = container.bind('logger', (container) => logger());
  }

  /// Register the HTTP client
  void _registerHttp(HttpConfigContract Function(Environment) http) {
    final config = http(environment);

    this.http = container.bind<DiscordHttpClient>('http', (_) =>
      DiscordHttpClient(logger: logger, baseUrl: '${config.baseUrl}/v${config.version}')
        ..headers.setContentType('application/json')
        ..headers.setAuthorization('Bot $token')
        ..headers.setUserAgent('Mineral')
    );
  }

  void _createHmr({ bool reloadable = false }) {
    final watcher = Hmr(
      appRoot: Directory.current,
      allowReload: reloadable,
      application: application,
      roots: [Directory(join(Directory.current.path, 'lib'))]
    );

    watcher.watch();
  }

  void _registerConsole (ConsoleConfigContract Function() console) {
    final config = console();

    this.console = container.bind<Console>('console', (_) => Console(logger));
    this.console
      ..addCommand(HelpCommand())
      ..addCommand(GenerateEnvironmentCommand(logger));

    for (final command in config.commands) {
      this.console.addCommand(command);
    }
  }

  factory Kernel.makeApplication({
    required ApplicationConfigContract Function(Environment) application,
    required LoggerContract Function() logger,
    required HttpConfigContract Function(Environment) http,
  }) => Kernel._application(application, logger, http);

  factory Kernel.makeConsole({
    required LoggerContract Function() logger,
    required ConsoleConfigContract Function() console,
  }) => Kernel._console(logger, console);
}