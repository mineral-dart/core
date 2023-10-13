import 'dart:io';
import 'dart:isolate';

import 'package:mineral/commands/generate_environment_command.dart';
import 'package:mineral/commands/help_command.dart';
import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/app/embedded_development.dart';
import 'package:mineral/internal/app/embedded_production.dart';
import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/console_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/console/console.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/internal/watcher/watcher_builder.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  late final LoggerContract logger;
  late final Console console;
  late final DiscordHttpClient http;

  late final String appEnv;
  late final String token;
  late final Intents intents;
  late final bool useHmr;

  late final WebsocketManager websocketManager;
  late final EmbeddedApplication application;

  Kernel._application(ApplicationConfigContract Function(Environment) app, LoggerContract Function() logger, HttpConfigContract Function(Environment) http) {
    _registerApplication(app);
    _registerLogger(logger);
    _registerHttp(http);

    switch (appEnv) {
      case 'development': _startDevelopmentApplication();
      case 'production': _startProductionApplication();
    }
  }

  Kernel._console(LoggerContract Function() logger, ConsoleConfigContract Function() console) {
    _registerLogger(logger);
    _registerConsole(console);
  }

  void _startDevelopmentApplication () {
    application = EmbeddedDevelopment(logger);
    final app = application as EmbeddedDevelopment;

    websocketManager = WebsocketManager(
      application: application,
      http: http,
      token: token,
      intents: intents
    );

    if (Isolate.current.debugName != app.debugName) {
      final embedded = application as EmbeddedDevelopment;

      _createHmr(reloadable: useHmr);
      websocketManager.start(shardCount: 1);

      embedded.createAndListen();
    }
  }

  void _startProductionApplication () {
    application = EmbeddedProduction(logger);

    websocketManager = WebsocketManager(
      application: application as EmbeddedProduction,
      http: http,
      token: token,
      intents: intents
    );

    websocketManager.start(shardCount: 1);
  }

  /// Register the application
  void _registerApplication (ApplicationConfigContract Function(Environment) app) {
    final application = app(environment);

    appEnv = application.appEnv;
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
    String makeRelativePath (String path) =>
        path.replaceFirst(Directory.current.path, '').substring(1);

    final watcher = WatcherBuilder(Directory.current)
      .setApplication(application as EmbeddedDevelopment)
      .setAllowReload(reloadable)
      .addWatchFolder(Directory(join(Directory.current.path, 'lib')))
      .onReload((event) {
        final String location = makeRelativePath(event.path);

        switch (event.type) {
          case ChangeType.ADD: logger.info('File added: $location');
          case ChangeType.MODIFY: logger.info('File modified: $location');
          case ChangeType.REMOVE: logger.info('File removed: $location');
        }

        if (application is EmbeddedDevelopment) {
          logger.info('Restarting application...');
          (application as EmbeddedDevelopment).restart();
        }
      })
      .build();

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