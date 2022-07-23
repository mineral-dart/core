import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

extension FetchableCacheManagerExtension<T> on FetchableCacheManager<T> {
  Future<T?> getOrFetch(Snowflake id) async {
    if(cache.containsKey(id)) return cache.get(id);
    return fetch(id);
  }
}