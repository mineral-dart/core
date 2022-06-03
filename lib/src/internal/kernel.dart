import 'package:mineral/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/store_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_manager.dart';

class Kernel {
  EventManager events = EventManager();
  CommandManager commands = CommandManager();
  StoreManager stores = StoreManager();
  List<Intent> intents = [];

  Kernel() {
    ioc.bind(namespace: ioc.services.event, service: events);
    ioc.bind(namespace: ioc.services.command, service: commands);
    ioc.bind(namespace: ioc.services.store, service: stores);
  }

  Future<void> init () async {
    Http http = Http(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    ioc.bind(namespace: ioc.services.http, service: http);

    Environment environment = await _loadEnvironment();
    WebsocketManager manager = WebsocketManager(http);
    ioc.bind(namespace: Service.websocket, service: manager);
    //WebsocketManager manager = WebsocketManager(http);

    String? token = environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException(
        prefix: 'MISSING TOKEN',
        cause: 'APP_TOKEN is not defined in your environment'
      );
    }

    ShardManager manager = ShardManager(http, token);
    manager.start(shardsCount: 2);
    //await manager.connect(token: token);
  }


  Future<Environment> _loadEnvironment () async {
    Environment environment = Environment();
    ioc.bind(namespace: ioc.services.environment, service: environment);

    return await environment.load('.env');
  }
}
