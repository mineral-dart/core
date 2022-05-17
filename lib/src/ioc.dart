class IocContainer {
  static late IocContainer _instance;
  final Map<String, dynamic> _services = {};

  static IocContainer init () {
    IocContainer._instance = IocContainer();
    return IocContainer._instance;
  }

  void bind<T> ({ required String namespace, required T service }) {
    _services.putIfAbsent(namespace, () => service);
  }

  singleton (String namespace) {
    return IocContainer._instance._services[namespace];
  }
}

IocContainer ioc = IocContainer.init();
