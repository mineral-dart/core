import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

abstract class CacheManager<T> {
  Collection<Snowflake, T> cache = Collection();

  Future<Collection<Snowflake, T>> sync () async {
    throw UnimplementedError();
  }
}
