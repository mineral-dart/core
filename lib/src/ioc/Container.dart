class IocContainer {
  static late IocContainer _instance;
  final Map<Symbol, dynamic> _services = {};

  static IocContainer init () {
    IocContainer._instance = IocContainer();
    return IocContainer._instance;
  }

  void bind<T> ({ required Symbol namespace, required T service }) {
    _services.putIfAbsent(namespace, () => service);
  }

  singleton (Symbol namespace) {
    return IocContainer._instance._services[namespace];
  }
}
