import 'dart:collection';
import 'package:mineral/src/domains/common/utils/helper.dart';

final class IocContainer {
  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic> _defaults = {};

  UnmodifiableMapView<Type, dynamic> get services =>
      UnmodifiableMapView(_services);

  UnmodifiableMapView<Type, dynamic> getServices() =>
      UnmodifiableMapView(_services);

  void bind<T>(T Function() fn) {
    final service = fn();
    _services[T] = service;
    _defaults[T] = service;
  }

  T make<T>(T Function() clazz) {
    _services[T] = clazz();
    return _services[T];
  }

  T resolve<T>() {
    final service = _services[T];

    return switch (service) {
      null => throw Exception('Service "$T" not found'),
      _ => service,
    };
  }

  T? resolveOrNull<T>() => _services[T];

  void override<T>(T key, Constructable<T> clazz) {
    if (!_services.containsKey(key)) {
      throw Exception('Service not exists, you can\t override it');
    }

    _services[key as Type] = clazz();
  }

  void restore<T extends Type>(T key) {
    if (!_services.containsKey(key)) {
      throw Exception('Service not exists, you can\t restore it');
    }

    _services[key] = _defaults[key];
  }

  void dispose() {
    _services.clear();
    _defaults.clear();
  }
}

final ioc = IocContainer();
