import 'package:mineral/src/collection.dart';
import 'package:mineral/src/constants.dart';

abstract class CacheManager<T> {
  Collection<Snowflake, T> cache = Collection();
}
