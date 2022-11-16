import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:mineral/src/internal/entities/state.dart';
import 'package:mineral_ioc/ioc.dart';

class StateManager extends MineralService {
  final Map<Type, MineralState> _stores = {};

  StateManager(): super(inject: true);

  void register (List<MineralState> mineralStates) {
    for (final store in mineralStates) {
      if (_stores.containsKey(store.name)) {
        throw AlreadyExist(cause: "A store named ${store.name} already exists.");
      }
      _stores.putIfAbsent(store.runtimeType, () => store);
    }
  }

  T getStore<T> () {
    if (!_stores.containsKey(T)) {
      throw NotExist(cause: "The bind $T does not exist in your project.");
    }

    return _stores.getOrFail(T);
  }
}
