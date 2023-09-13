import 'package:mineral/commands/generate_environment_command.dart';
import 'package:mineral/commands/help_command.dart';
import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/console_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/console/console.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  late final LoggerContract logger;
  late final Console console;
  late final DiscordHttpClient http;

  late final String token;
  late final Intents intents;

  Kernel._application(ApplicationConfigContract Function(Environment) app, LoggerContract Function() logger, HttpConfigContract Function(Environment) http) {
    _registerApplication(app);
    _registerLogger(logger);
    _registerHttp(http);

    this.logger.info('Kernel is ready');
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
  }

  /// Register the logger
  void _registerLogger(LoggerContract Function() logger) {
    this.logger = container.bind('logger', (container) => logger());
  }

  /// Register the HTTP client
  void _registerHttp(HttpConfigContract Function(Environment) http) {
    final config = http(environment);

    this.http = container.bind<DiscordHttpClient>('http', (_) =>
      DiscordHttpClient(baseUrl: '${config.baseUrl}/v${config.version}')
        ..headers.setContentType('application/json')
        ..headers.setAuthorization('Bot $token')
    );
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