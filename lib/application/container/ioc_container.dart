final class IocContainer {
  static late final IocContainer _instance;

  final Map<dynamic, dynamic> _services = {};

  IocContainer._() {
    IocContainer._instance = this;
  }

  void bind<T>(String key, T Function() fn) {
    _services[key] = fn();
  }

  T make<T>(T Function() clazz) {
    _services[T] = clazz;
    return _services[T];
  }

  T resolve<T>(String key) {
    return _services[key];
  }

  factory IocContainer.init() => IocContainer._();
}

final ioc = IocContainer.init();
