import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ChannelManager extends CacheManager<GuildChannel> {
  final Snowflake _guildId;

  ChannelManager(this._guildId);

  Guild get guild => ioc.singleton<MineralClient>(ioc.services.client).guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, GuildChannel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$_guildId/channels");
    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      final GuildChannel? channel = ChannelWrapper.create(element);

      if (channel != null) {
        cache.putIfAbsent(channel.id, () => channel);
      }
    }

    return cache;
  }

  Future<T?> create<T extends GuildChannel> (ChannelBuilder builder) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.post(url: '/guilds/$_guildId/channels', payload: builder.payload);
    dynamic payload = jsonDecode(response.body);

    final GuildChannel? channel = ChannelWrapper.create(payload);
    return channel as T;
  }
}
