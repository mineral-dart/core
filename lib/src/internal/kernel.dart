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

  Kernel prepare () {
    ioc.bind(namespace: Service.event, service: events);
    ioc.bind(namespace: Service.command, service: commands);
    ioc.bind(namespace: Service.store, service: stores);

    return this;
  }

  Future<void> init () async {
    Http http = Http(baseUrl: 'https://discord.com/api');
    http.defineHeader(header: 'Content-Type', value: 'application/json');
    ioc.bind(namespace: Service.http, service: http);

    Environment environment = await _loadEnvironment();
    WebsocketManager manager = WebsocketManager(http);
    ioc.bind(namespace: Service.websocket, service: manager);

    String? token = environment.get('APP_TOKEN');
    if (token == null) {
      throw TokenException(
        prefix: 'MISSING TOKEN',
        cause: 'APP_TOKEN is not defined in your environment'
      );
    }

    await manager.connect(token: token);
  }


  Future<Environment> _loadEnvironment () async {
    Environment environment = Environment();
    ioc.bind(namespace: Service.environment, service: environment);

    return await environment.load('.env');
  }
}
