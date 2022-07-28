import 'package:mineral/api.dart';

abstract class CacheManager<T> {
  final Map<Snowflake, T> _cache = {};
  Map<Snowflake, T> get cache => _cache;
}
