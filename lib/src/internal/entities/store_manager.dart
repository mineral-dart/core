import 'package:mineral/src/exceptions/already_exist.dart';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:mineral/src/internal/entities/file_entity.dart';

class StoreManager {
  final Map<String, FileEntity> _stores = {};

  StoreManager add (FileEntity fileEntity) {
    String name = fileEntity.instanceMirror.type.metadata.first.reflectee.name;
    if (_stores.containsKey(name)) {
      throw AlreadyExist(cause: "A store named $name already exists.");
    }

    _stores[name] = fileEntity;

    return this;
  }

  StoreManager addAll (List<FileEntity> fileEntities) {
    for (FileEntity fileEntity in fileEntities) {
      String name = fileEntity.instanceMirror.type.metadata.first.reflectee.name;
      if (_stores.containsKey(name)) {
        throw AlreadyExist(cause: "A store named $name already exists.");
      }

      _stores[name] = fileEntity;
    }

    return this;
  }

  T getStore<T> (String store) {
    if (!_stores.containsKey(store)) {
      throw NotExist(cause: "The blind $store does not exist in your project.");
    }

    FileEntity? fileEntity = _stores[store];
    return fileEntity?.instanceMirror.reflectee;
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
