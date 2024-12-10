import 'dart:async';

import 'package:mineral/src/domains/contracts/logger/logger_contract.dart';

abstract interface class CacheProviderContract {
  String get name;

  abstract LoggerContract logger;

  FutureOr<void> init();

  FutureOr<int> length();

  FutureOr<Map<String, dynamic>> inspect();

  FutureOr<Map<String, dynamic>?> get(String? key);

  FutureOr<List<Map<String, dynamic>?>> getMany(List<String> keys);

  FutureOr<Map<String, dynamic>> getOrFail(String key,
      {Exception Function()? onFail});

  FutureOr<Map<String, dynamic>?> whereKeyStartsWith(String prefix);

  FutureOr<Map<String, dynamic>> whereKeyStartsWithOrFail(String prefix,
      {Exception Function()? onFail});

  FutureOr<bool> has(String key);

  FutureOr<void> put<T>(String key, T object);

  FutureOr<void> putMany<T>(Map<String, T> object);

  FutureOr<void> remove(String key);

  FutureOr<void> removeMany(List<String> key);

  FutureOr<void> clear();

  FutureOr<void> dispose();

  FutureOr<bool> getHealth();
}
