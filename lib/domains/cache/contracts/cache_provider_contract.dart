import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class CacheProviderContract {
  String get name;

  abstract LoggerContract logger;

  FutureOr<void> init();

  Future<int> length();
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>?> get(Snowflake? key);
  Future<Map<String, dynamic>> getOrFail(Snowflake key, { Exception Function()? onFail });
  Future<bool> has(Snowflake key);
  Future<void> put<T>(Snowflake key, T object);
  Future<void> remove(Snowflake key);
  Future<void> removeMany(List<Snowflake> key);
  Future<void> clear();

  Future<void> dispose();
  Future<bool> getHealth();
}
