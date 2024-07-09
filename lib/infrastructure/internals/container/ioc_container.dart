final class IocContainer {
  static late final IocContainer _instance;

  final Map<Type, dynamic> _services = {};

  IocContainer._() {
    IocContainer._instance = this;
  }

  void bind<T>(Type key, T Function() fn) {
    _services[key] = fn();
  }

  T make<T>(T Function() clazz) {
    _services[T] = clazz;
    return _services[T];
  }

  T resolve<T>() {
    return _services[T];
  }

  factory IocContainer.init() => IocContainer._();
}

final ioc = IocContainer.init();
