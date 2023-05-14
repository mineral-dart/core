import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/not_exist_exception.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:collection/collection.dart';

class ComponentService extends MineralService implements ComponentServiceContract {
  final Map<Type, InteractiveComponent> _collectors = {};

  ComponentService(List<InteractiveComponent> components): super(inject: true) {
    for (final component in components) {
      _collectors.putIfAbsent(component.runtimeType, () => component);
    }
  }

  void subscribe (InteractiveComponent component) {
    _collectors.putIfAbsent(component.runtimeType, () => component);
  }

  void unsubscribe (InteractiveComponent collector) {
    _collectors.remove(collector.customId);
  }

  void emit (String customId, dynamic payload) {
    final collector = _collectors.values.firstWhereOrNull((element) => element.customId == customId);
    if (collector != null) {
      collector.handle(payload);
    }
  }

  @override
  T get<T extends InteractiveComponentContract> () {
    if (!_collectors.containsKey(T)) {
      throw NotExistException('The component named $T does not exist on your project.');
    }

    return _collectors[T] as T;
  }
}
