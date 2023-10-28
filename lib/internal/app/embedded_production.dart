import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/factories/events/contracts/event_contract.dart';
import 'package:mineral/internal/factories/events/event_factory.dart';
import 'package:mineral/internal/factories/packages/contracts/package_contract.dart';
import 'package:mineral/internal/factories/packages/package_factory.dart';
import 'package:mineral/internal/factories/states/contracts/state_contract.dart';
import 'package:mineral/internal/factories/states/state_factory.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger.dart';

final class EmbeddedProduction implements EmbeddedApplication {
  final EventFactory _eventFactory = EventFactory();
  late final PackageFactory _packageFactory;
  late final StateFactory _stateFactory;

  late final WebsocketEventDispatcher _dispatcher;
  late WebsocketManager websocket;
  final Logger logger;
  final Environment environment;
  late final DiscordHttpClient http;

  String get appEnv => environment.get('APP_ENV');
  String get token => environment.get('APP_TOKEN');
  int get intents => int.parse(environment.get('INTENTS'));
  bool get useHmr => bool.parse(environment.get('HMR'));

  EmbeddedProduction({
    required this.logger,
    required this.environment,
    required this.http,
    required List<EventContract Function()> events,
    required List<PackageContract Function()> packages,
    required List<StateContract Function()> states,
  }) {
    _eventFactory.registerMany(events);
    _dispatcher = WebsocketEventDispatcher(_eventFactory);

    _packageFactory = PackageFactory(logger.app);
    _packageFactory.registerMany(packages);
    _packageFactory.init();

    _stateFactory = StateFactory();
    _stateFactory.registerMany(states);
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