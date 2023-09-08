import 'package:mineral/internal/config/application_config_contract.dart';
import 'package:mineral/internal/config/http_config_contract.dart';
import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class Kernel {
  final Environment environment = container.bind('environment', (_) => Environment());
  late final LoggerContract logger;
  late final DiscordHttpClient http;

  late final String token;
  late final Intents intents;

  Kernel._(ApplicationConfigContract Function(Environment) app, LoggerContract Function() logger, HttpConfigContract Function() http) {
    _registerApplication(app);
    _registerLogger(logger);
    _registerHttp(http);

    this.logger.info('Kernel is ready');
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
  void _registerHttp(HttpConfigContract Function() http) {
    final config = http();

    this.http = container.bind<DiscordHttpClient>('http', (_) =>
      DiscordHttpClient(baseUrl: '${config.baseUrl}/v${config.version}')
        ..headers.setContentType('application/json')
        ..headers.setAuthorization('Bot $token')
    );
  }

  factory Kernel.make({
    required ApplicationConfigContract Function(Environment) application,
    required LoggerContract Function() logger,
    required HttpConfigContract Function() http,
  }) => Kernel._(application, logger, http);
}