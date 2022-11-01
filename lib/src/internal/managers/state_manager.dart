import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:mineral/src/internal/entities/state.dart';

class StateManager {
  final Map<String, MineralState> _stores = {};

  void register (List<MineralState> mineralStates) {
    for (final store in mineralStates) {
      if (_stores.containsKey(store.name)) {
        throw AlreadyExist(cause: "A store named ${store.name} already exists.");
      }
      _stores.putIfAbsent(store.name, () => store);
    }
  }

  T getStore<T> (String store) {
    if (!_stores.containsKey(store)) {
      throw NotExist(cause: "The bind $store does not exist in your project.");
    }

    return _stores.getOrFail(store);
  }
}
