import 'package:mineral/internal/fold/injectable.dart';

/// The Container package is one of the core components of the Mineral framework, in fact it registers the entire application through its Container.
final class Container {
  final Map<String, dynamic> _services = {};

  /// Registers a new injectable instance within the [Container]
  /// ```dart
  /// final container = Container();
  ///
  /// expect(container.bind('foo', (container) => Foo()), isA<Foo>());
  /// expect(container.length(), 1);
  /// ```
  T bind<T extends Injectable> (String binding, T Function(Container) injectable) {
    if (_services.containsKey(binding)) {
      throw Exception('Service $binding already exists');
    }

    final injectableInstance = injectable(this);
    _services.putIfAbsent(binding, () => injectableInstance);

    return injectableInstance;
  }

  /// Resolve the service instance from its namespace
  /// ```dart
  /// final myService = container.use<MyService>('binding');
  /// ```
  T use<T extends Injectable> (String binding) {
    if (!_services.containsKey(binding)) {
      throw Exception('Service $binding does not exist');
    }

    return _services[binding];
  }

  /// Deletes a service registered in the
  /// /// ```dart
  /// container.remove('binding');
  /// ```
  void remove (String binding) {
    if (!_services.containsKey(binding)) {
      throw Exception('Service $binding does not exist');
    }

    _services.remove(binding);
  }

  void removeBindings () {
    _services.clear();
  }

  int length () => _services.length;
}