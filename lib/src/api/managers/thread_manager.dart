import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class ThreadManager extends CacheManager<ThreadChannel>  {
  final Snowflake _guildId;

  ThreadManager(this._guildId);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, ThreadChannel>> sync () async {
    cache.clear();

    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/guilds/$_guildId/threads/active")
      .build();

    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      ThreadChannel thread = ThreadChannel.fromPayload(element);
      cache.putIfAbsent(thread.id, () => thread);
    }

    return cache;
  }

  Future<ThreadChannel?> create ({ required String label, required TextBasedChannel channel, int autoArchiveDuration = 60, bool isPrivate = false }) async {
    Response response = await ioc.use<DiscordApiHttpService>().post(url: '/channels/${channel.id}/threads')
        .payload({
          'name': label,
          'auto_archive_duration': autoArchiveDuration,
          'type': isPrivate ? ChannelType.guildPrivateThread.value : ChannelType.guildPublicThread.value,
          'invitable': isPrivate,
         }).build();

    return ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId).channels.cache.getOrFail(jsonDecode(response.body)['id']);
  }

  Future<ThreadChannel> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/guilds/$_guildId/channels/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      ThreadChannel thread = ThreadChannel.fromPayload(payload);

      cache.putIfAbsent(thread.id, () => thread);
      return thread;
    }

    throw ApiException('Unable to fetch thread with id #$id');
  }
}
