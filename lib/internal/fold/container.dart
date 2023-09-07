import 'package:mineral/internal/fold/injectable.dart';

final class Container {
  final Map<String, dynamic> _services = {};

  T bind<T extends Injectable> (String binding, T Function(Container) injectable) {
    if (_services.containsKey(binding)) {
      throw Exception('Service $binding already exists');
    }

    final injectableInstance = injectable(this);
    _services.putIfAbsent(binding, () => injectableInstance);

    return injectableInstance;
  }

  T use<T extends Injectable> (String binding) {
    if (!_services.containsKey(binding)) {
      throw Exception('Service $binding does not exist');
    }

    return _services[binding];
  }

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