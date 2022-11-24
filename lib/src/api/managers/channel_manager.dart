import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class ChannelManager extends CacheManager<GuildChannel> with Container {
  final Snowflake _guildId;

  ChannelManager(this._guildId);

  Guild get guild => container.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, GuildChannel>> sync () async {
    final _cached = cache.clone;
    cache.clear();

    Response response = await container.use<Http>().get(url: "/guilds/$_guildId/channels");
    dynamic payload = jsonDecode(response.body);

    if (response.statusCode != 200) {
      cache.addAll(_cached);
      return cache;
    }

    for (dynamic element in payload) {
      final GuildChannel? channel = ChannelWrapper.create(element);

      if (channel != null) {
        cache.putIfAbsent(channel.id, () => channel);
      }
    }

    return cache;
  }

  Future<T?> create<T extends GuildChannel> (ChannelBuilder builder) async {
    Response response = await container.use<Http>().post(url: '/guilds/$_guildId/channels', payload: builder.payload);
    dynamic payload = jsonDecode(response.body);

    final GuildChannel? channel = ChannelWrapper.create(payload);
    return channel as T?;
  }
}
