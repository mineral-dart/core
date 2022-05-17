import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class ChannelManager implements CacheManager<Channel> {
  @override
  Collection<Snowflake, Channel> cache = Collection();
}
