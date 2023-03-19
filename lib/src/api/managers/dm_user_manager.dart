import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/users/dm_user.dart';
import 'package:mineral_ioc/ioc.dart';

class DmUserManager extends CacheManager<DmUser> {
  final Snowflake _channelId;

  DmUserManager(this._channelId);

  Future<void> add ({ required Snowflake id, required Snowflake nickname, required String accessToken }) async {
    await ioc.use<DiscordApiHttpService>()
      .put(url: '/channels/$_channelId/recipients/$id')
      .payload({ 'access_token': accessToken, 'nick': nickname })
      .build();
  }
}
