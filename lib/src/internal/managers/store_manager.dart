import 'dart:mirrors';

import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/exceptions/not_exist.dart';

class StoreManager {
  final Map<String, dynamic> _stores = {};

  void register (List<MineralStore> mineralStores) {
    for (final store in mineralStores) {
      String name = reflect(store).type.metadata.first.reflectee.name;
      if (_stores.containsKey(name)) {
        throw AlreadyExist(cause: "A store named $name already exists.");
      }

      store.environment = ioc.singleton(Service.environment);
      _stores[name] = store;
    }
  }

  T getStore<T> (String store) {
    if (!_stores.containsKey(store)) {
      throw NotExist(cause: "The blind $store does not exist in your project.");
    }

    return _stores[store];
  }
}
