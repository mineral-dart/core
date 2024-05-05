import 'dart:async';

import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class CacheProviderContract {
  String get name;

  abstract LoggerContract logger;

  FutureOr<void> init();

  Future<int> length();
  Future<List<T>> getAll<T extends dynamic>();
  Future<String?> get(String? key);
  Future<String> getOrFail(String key, { Exception Function()? onFail });
  Future<bool> has(String key);
  Future<void> put<T>(String key, T object);
  Future<void> remove(String key);
  Future<void> removeMany(List<String> key);
  Future<void> clear();

  Future<void> dispose();
  Future<bool> getHealth();
}
