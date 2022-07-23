class Service {
  final http = 'Mineral/Core/Http';
  final client = 'Mineral/Core/Client';
  final environment = 'Mineral/Core/Environment';
  final event = 'Mineral/Core/Event';
  final command = 'Mineral/Core/Command';
  final store = 'Mineral/Core/Store';
  final modules = 'Mineral/Core/Modules';
  final cli = 'Mineral/Core/Cli';
  final shards = 'Mineral/Core/Shards';
  final reporter = 'Mineral/Core/Reporter';
  final contextMenu = 'Mineral/Core/ContextMenu';
}

class Ioc {
  Service services = Service();
  static late Ioc _instance;
  final Map<String, dynamic> _services = {};

  static Ioc init () {
    Ioc._instance = Ioc();
    return Ioc._instance;
  }

  void bind<T> ({ required String namespace, required T service }) {
    _services.putIfAbsent(namespace, () => service);
  }

  singleton (String namespace) {
    return Ioc._instance._services[namespace];
  }
}

Ioc ioc = Ioc.init();
