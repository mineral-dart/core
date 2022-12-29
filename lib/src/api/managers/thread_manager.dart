import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral_ioc/ioc.dart';

class ThreadManager extends CacheManager<ThreadChannel>  {
  final Snowflake _guildId;

  ThreadManager(this._guildId);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, ThreadChannel>> sync () async {
    cache.clear();

    Response response = await ioc.use<HttpService>().get(url: "/guilds/$_guildId/threads/active");
    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      ThreadChannel thread = ThreadChannel.fromPayload(element);
      cache.putIfAbsent(thread.id, () => thread);
    }

    return cache;
  }

  Future<ThreadChannel?> create<T extends GuildChannel> ({ Snowflake? messageId, String? label }) async {
    MineralClient client = ioc.use<MineralClient>();
    return await client.createChannel(_guildId, ChannelBuilder({
      'name': label,
      'auto_archive_duration': '60',
      'type': ChannelType.guildPublicThread.value
    }));
  }
}
