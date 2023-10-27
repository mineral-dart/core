import 'dart:isolate';

import 'package:mineral/commands/configure_command.dart';
import 'package:mineral/commands/generate_environment_command.dart';
import 'package:mineral/commands/help_command.dart';
import 'package:mineral/internal/app/embedded_development.dart';
import 'package:mineral/internal/app/embedded_dispatcher.dart';
import 'package:mineral/internal/app/embedded_production.dart';
import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/console_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/services/console/console.dart';
import 'package:mineral/internal/factories/packages/package_factory.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  Console? console;

  late final PackageFactory packages;
  late final DiscordHttpClient httpClient;
  late final Logger logger;
  late ApplicationConfigContract configApp;
  SendPort? _devPort;

  Kernel();

  /// Set the application configuration
  Kernel setApplication(ApplicationConfigContract Function(Environment) config) {
    configApp = config(environment);

    logger = Logger()
      ..setRootLogLevel(configApp.logLevel)
      ..setRootListener(configApp.logger);

    environment
      ..set('APP_ENV', configApp.appEnv)
      ..set('APP_TOKEN', configApp.token)
      ..set('INTENTS', configApp.intents.calculatedValue.toString())
      ..set('HMR', configApp.hmr.toString());

    packages = container.bind('Mineral/Factories/Package', (_) =>
      PackageFactory(logger.app)
        ..registerMany(configApp.packages));

    return this;
  }

  /// Set the http client to communicate with the discord api
  Kernel setHttp(HttpConfigContract Function(Environment) http) {
    final config = http(environment);

    httpClient = container.bind<DiscordHttpClient>('http', (_) =>
      DiscordHttpClient(logger: logger.http, baseUrl: '${config.baseUrl}/v${config.version}')
        ..headers.setContentType('application/json')
        ..headers.setUserAgent('Mineral')
      );

    logger.http.fine('Http client initialized { Isolate: ${Isolate.current.debugName} }');
    logger.http.finest('Default configuration { '
        'baseUrl: ${httpClient.baseUrl}, '
        'headers: ${httpClient.headers.all}, '
        'Authorization: Bot **** '
      '}'
    );

    httpClient.headers.setAuthorization('Bot ${configApp.token}');

    return this;
  }

  /// Set the development port to communicate with the development server
  /// [SendPort] The port to communicate with the development server
  ///
  Kernel setDevelopmentPort (SendPort? port) {
    _devPort = port;
    return this;
  }

  Future<void> start () async {
    if (Isolate.current.debugName == 'dev') {
      return EmbeddedDispatcher(_devPort, logger.app, configApp.events, configApp.packages)
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
        packages: configApp.packages,
      ),
      _ => throw Exception('Invalid environment mode')
    };

    app.spawn();
  }

  Kernel setConsole(ConsoleConfigContract Function() config) {
    final consoleConfig = config();

    console = container.bind<Console>('Mineral/Factories/Console', (_) => Console(logger))
      ..addCommand(HelpCommand(logger.console))
      ..addCommand(GenerateEnvironmentCommand(logger.console))
      ..addCommand(ConfigureCommand(logger.console));

    for (final command in consoleConfig.commands) {
      console?.addCommand(command);
    }

    return this;
  }

  void handle (List<String> arguments) {
    console?.handle(arguments);
  }
}