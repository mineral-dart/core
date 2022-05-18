import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildManager implements CacheManager<Guild> {
  @override
  Collection<Snowflake, Guild> cache = Collection();

  @override
  Future<Collection<Snowflake, Guild>> sync() {
    throw UnimplementedError();
  }
}
