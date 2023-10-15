import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/factories/contracts/event_contract.dart';
import 'package:mineral/internal/factories/event_factory.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class EmbeddedProduction implements EmbeddedApplication {
  final EventFactory _factory = EventFactory();
  late final WebsocketEventDispatcher _dispatcher;
  late WebsocketManager websocket;
  final Logger logger;
  final Environment environment;
  late final DiscordHttpClient http;


  String get appEnv => environment.get('APP_ENV');
  String get token => environment.get('APP_TOKEN');
  int get intents => int.parse(environment.get('INTENTS'));
  bool get useHmr => bool.parse(environment.get('HMR'));

  EmbeddedProduction({ required this.logger, required this.environment, required this.http, required List<EventContract Function()> events }) {
    _factory.events.addAll(events);
    _dispatcher = WebsocketEventDispatcher(_factory);
  }

  @override
  void spawn() {
    websocket = WebsocketManager(
      logger: logger.wss,
      token: token,
      intents: intents,
      http: http,
      dispatcher: dispatch
    );

    websocket.start(shardCount: 1);
  }

  void dispatch(Map<String, dynamic> message) {
    final response = WebsocketResponse.fromWebsocket(message);
    _dispatcher.dispatch(response);
  }
}