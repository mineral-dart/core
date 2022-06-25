import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildManager implements CacheManager<Guild> {
  @override
  Map<Snowflake, Guild> cache = {};

  @override
  Future<Map<Snowflake, Guild>> sync() {
    throw UnimplementedError();
  }
}
