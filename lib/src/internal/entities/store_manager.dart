import 'dart:mirrors';

import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/exceptions/not_exist.dart';

class StoreManager {
  final Map<String, dynamic> _stores = {};

  StoreManager add (MineralStore store) {
    String name = reflect(store).type.metadata.first.reflectee.name;
    if (_stores.containsKey(name)) {
      throw AlreadyExist(cause: "A store named $name already exists.");
    }

    _stores[name] = store;
    return this;
  }

  T getStore<T> (String store) {
    if (!_stores.containsKey(store)) {
      throw NotExist(cause: "The blind $store does not exist in your project.");
    }

    return _stores[store];
  }
}

class Store {
  final String type = 'store';
  final String name;

  const Store(this.name);
}

abstract class MineralStore<T> {
  late T state;
}
