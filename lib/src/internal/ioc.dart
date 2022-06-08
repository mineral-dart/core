class Ioc {
  static late Ioc _instance;
  final Map<Service, dynamic> _services = {};

  static Ioc init () {
    Ioc._instance = Ioc();
    return Ioc._instance;
  }

  void bind<T> ({ required Service namespace, required T service }) {
    _services.putIfAbsent(namespace, () => service);
  }

  singleton (Service namespace) {
    return Ioc._instance._services[namespace];
  }
}

enum Service {
  http('Mineral/Core/Http'),
  client('Mineral/Core/Client'),
  environment('Mineral/Core/Environment'),
  event('Mineral/Core/Event'),
  command('Mineral/Core/Command'),
  websocket('Mineral/Core/Websocket');

  final String _symbol;
  const Service(this._symbol);

  @override
  String toString () => _symbol;
}

Ioc ioc = Ioc.init();
