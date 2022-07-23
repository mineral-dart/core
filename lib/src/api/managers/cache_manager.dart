import 'package:mineral/api.dart';

abstract class CacheManager<T> {
  Map<Snowflake, T> cache = {};

  Future<Map<Snowflake, T>> sync () async {
    throw UnimplementedError();
  }
}

abstract class FetchableCacheManager<T> implements CacheManager<T> {
  Future<T?> fetch(Snowflake id);
}