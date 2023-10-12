import 'package:mineral/api/common/collection.dart';
import 'package:mineral/api/common/snowflake.dart';

abstract interface class CacheContract<T> {
  abstract final Collection<Snowflake, T> cache;

  Future<T> resolve(Snowflake id);
}