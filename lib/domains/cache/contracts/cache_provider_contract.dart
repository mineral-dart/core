import 'dart:async';

import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class CacheProviderContract<K> {
  String get name;

  abstract LoggerContract logger;

  FutureOr<void> init();

  Future<int> length();
  Future<List<T>> getAll<T extends dynamic>();
  Future<T?> get<T>(K? key);
  Future<T> getOrFail<T>(K key, { Exception Function()? onFail });
  Future<bool> has(K key);
  Future<void> put<T>(K key, T object);
  Future<void> remove(K key);
  Future<void> removeMany(List<K> key);
  Future<void> clear();

  Future<void> dispose();
  Future<bool> getHealth();
}
