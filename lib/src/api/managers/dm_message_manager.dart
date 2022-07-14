import 'package:mineral/api.dart';
import 'package:mineral/src/api/dm_message.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class DmMessageManager implements CacheManager<DmMessage> {
  @override
  Map<Snowflake, DmMessage> cache = {};

  final Snowflake _channelId;

  DmMessageManager(this._channelId);

  @override
  Future<Map<Snowflake, DmMessage>> sync() {
    throw UnimplementedError();
  }
}
