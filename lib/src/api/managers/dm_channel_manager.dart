import 'package:mineral/api.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class DmChannelManager implements CacheManager<DmChannel> {
  @override
  Map<Snowflake, DmChannel> cache = {};

  DmChannelManager();

  @override
  Future<Map<Snowflake, DmChannel>> sync () async {
    return cache;
  }
}
