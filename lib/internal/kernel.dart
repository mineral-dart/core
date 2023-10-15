import 'dart:isolate';

import 'package:mineral/commands/generate_environment_command.dart';
import 'package:mineral/commands/help_command.dart';
import 'package:mineral/internal/app/embedded_development.dart';
import 'package:mineral/internal/app/embedded_dispatcher.dart';
import 'package:mineral/internal/app/embedded_production.dart';
import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/console_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/console/console.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  Console? console;

  late final DiscordHttpClient httpClient;
  late final LoggerContract logger;
  late ApplicationConfigContract configApp;
  SendPort? _devPort;

  Kernel();

  Kernel setLogger(LoggerContract Function() logger) {
    this.logger = container.bind('logger', (container) => logger());
    return this;
  }

  Kernel setApplication(ApplicationConfigContract Function(Environment) config) {
    configApp = config(environment);
    environment
      ..set('APP_ENV', configApp.appEnv)
      ..set('APP_TOKEN', configApp.token)
      ..set('INTENTS', configApp.intents.calculatedValue.toString())
      ..set('HMR', configApp.hmr.toString());

    return this;
  }

  Kernel setHttp(HttpConfigContract Function(Environment) http) {
    final config = http(environment);

    httpClient = container.bind<DiscordHttpClient>('http', (_) =>
      DiscordHttpClient(logger: logger, baseUrl: '${config.baseUrl}/v${config.version}')
        ..headers.setContentType('application/json')
        ..headers.setAuthorization('Bot ${configApp.token}')
        ..headers.setUserAgent('Mineral')
      );

    return this;
  }

  Kernel setDevelopmentPort (SendPort? port) {
    _devPort = port;
    return this;
  }

  Future<void> start () async {
    if (Isolate.current.debugName == 'dev') {
      return EmbeddedDispatcher(_devPort, configApp.events)
        .spawn();
    }

    final app = switch (configApp.appEnv) {
      'development' => EmbeddedDevelopment(
        environment: environment,
        logger: logger,
        http: httpClient,
      ),
      'production' => EmbeddedProduction(
        environment: environment,
        logger: logger,
        http: httpClient,
        events: configApp.events,
      ),
      _ => throw Exception('Invalid environment mode')
    };

    app.spawn();
  }

  Kernel setConsole(ConsoleConfigContract Function() config) {
    final consoleConfig = config();

    console = container.bind<Console>('console', (_) => Console(logger))
      ..addCommand(HelpCommand())
      ..addCommand(GenerateEnvironmentCommand(logger));

    for (final command in consoleConfig.commands) {
      console?.addCommand(command);
    }

    return this;
  }

  void handle (List<String> arguments) {
    console?.handle(arguments);
  }
}