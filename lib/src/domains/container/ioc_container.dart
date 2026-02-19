import 'dart:async';
import 'dart:collection';
import 'package:mineral/src/domains/common/utils/helper.dart';

abstract interface class Disposable {
  FutureOr<void> dispose();
}

final class IocContainer {
  final IocContainer? _parent;
  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic> _defaults = {};
  final Set<Type> _requiredBindings = {};

  IocContainer([this._parent]);

  UnmodifiableMapView<Type, dynamic> get services =>
      UnmodifiableMapView(_services);

  IocContainer createScope() => IocContainer(this);

  void bind<T>(T Function() fn) {
    final service = fn();
    _services[T] = service;
    _defaults[T] = service;
  }

  T make<T>(T Function() clazz) {
    final instance = clazz();
    _services[T] = instance;
    return instance;
  }

  T resolve<T>() {
    final service = _services[T];

    return switch (service) {
      final T typed => typed,
      null when _parent != null => _parent.resolve<T>(),
      null => throw Exception('Service "$T" not found'),
      _ => throw Exception(
          'Service "$T" has incompatible type: ${service.runtimeType}'),
    };
  }

  T? resolveOrNull<T>() {
    final service = _services[T];
    if (service is T) {
      return service;
    }
    return _parent?.resolveOrNull<T>();
  }

  void override<T>(Constructable<T> clazz) {
    if (!_services.containsKey(T)) {
      throw Exception('Service "$T" does not exist, cannot override it');
    }

    _services[T] = clazz();
  }

  void restore<T>() {
    if (!_services.containsKey(T)) {
      throw Exception('Service "$T" does not exist, cannot restore it');
    }

    _services[T] = _defaults[T];
  }

  void require<T>() {
    _requiredBindings.add(T);
  }

  void validateBindings() {
    final missing =
        _requiredBindings.where((type) => !_services.containsKey(type));
    if (missing.isNotEmpty) {
      throw Exception('Missing required services: ${missing.join(', ')}');
    }
  }

  Future<void> dispose() async {
    for (final service in _services.values) {
      if (service case final Disposable disposable) {
        await disposable.dispose();
      }
    }
    _services.clear();
    _defaults.clear();
    _requiredBindings.clear();
  }
}

IocContainer _ioc = IocContainer();

IocContainer get ioc => _ioc;

IocContainer Function() scopedIoc(IocContainer container) {
  final previous = _ioc;
  _ioc = container;
  return () => _ioc = previous;
}
