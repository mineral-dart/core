part of core;

class Kernel {
  EventManager events = EventManager();

  Future<void> init () async {
    ioc.bind(namespace: Service.event, service: events);

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
