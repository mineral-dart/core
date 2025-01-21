import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/components/component_context.dart';

abstract interface class InteractiveComponentService {
  T get<T extends InteractiveComponent>(String customId);
}

abstract interface class InteractiveComponentManagerContract
    implements InteractiveComponentService {
  void register(InteractiveComponent component);

  void dispatch(String customId, List params);
}

final class InteractiveComponentManager implements InteractiveComponentManagerContract {
  final Map<String, InteractiveComponent> _components = {};

  @override
  void register(InteractiveComponent component) {
    _components[component.customId] = component;
  }

  @override
  void dispatch(String customId, List params) {
    final component = _components[customId];
    if (component != null) {
      Function.apply((component as dynamic).handle, params);
    }
  }

  @override
  T get<T extends InteractiveComponent>(String customId) =>
      _components.values.firstWhere((e) => e.customId == customId,
          orElse: () => throw Exception('Cannot found component')) as T;
}
