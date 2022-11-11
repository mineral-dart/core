
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/builders.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/thread_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/extensions/mineral_client.dart';

class ThreadManager extends CacheManager<ThreadChannel> {
  final Snowflake _guildId;

  ThreadManager(this._guildId);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.singleton<MineralClient>(Service.client).guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, ThreadChannel>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$_guildId/threads/active");
    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      ThreadChannel thread = ThreadChannel.fromPayload(element);
      cache.putIfAbsent(thread.id, () => thread);
    }

    return cache;
  }

  Future<ThreadChannel?> create<T extends GuildChannel> ({ Snowflake? messageId, String? label }) async {
    MineralClient client = ioc.singleton(Service.client);
    return await client.createChannel(_guildId, ChannelBuilder({
      'name': label,
      'auto_archive_duration': '60',
      'type': ChannelType.guildPublicThread.value
    }));
  }
}
