import 'package:mineral/api.dart';

abstract class CacheManager<T> {
  Map<Snowflake, T> cache = {};

  Future<Map<Snowflake, T>> sync () async {
    throw UnimplementedError();
  }
}
