final class IocContainer {
  final Map<Type, dynamic> _services = {};

  void bind<T>(Type key, T Function() fn) {
    _services[key] = fn();
  }

  T make<T>(T Function() clazz) {
    _services[T] = clazz;
    return _services[T];
  }

  T resolve<T>() {
    final service = _services[T];

    return switch(service) {
      null => throw Exception('Service not found'),
      _ => service,
    };
  }
}

final ioc = IocContainer();
