import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class CacheProviderContract {
  String get name;

  abstract LoggerContract logger;

  FutureOr<void> init();

  Future<int> length();
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>?> get(String? key);
  Future<Map<String, dynamic>> getOrFail(String key, { Exception Function()? onFail });
  Future<bool> has(String key);
  Future<void> put<T>(String key, T object);
  Future<void> remove(String key);
  Future<void> removeMany(List<String> key);
  Future<void> clear();

  Future<void> dispose();
  Future<bool> getHealth();
}
