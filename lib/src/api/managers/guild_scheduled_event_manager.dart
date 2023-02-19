import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildScheduledEventService extends CacheManager<GuildScheduledEvent>  {
  late final Guild guild;

  Future<Map<Snowflake, GuildScheduledEvent>> sync() async {
    Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: "/guilds/${guild.id}/scheduled-events")
        .build();

    if (response.statusCode == 200) {
      cache.clear();

      dynamic payload = jsonDecode(response.body);
      for (dynamic element in payload) {
        GuildScheduledEvent event = GuildScheduledEvent.from(
          channelManager: guild.channels,
          memberManager: guild.members,
          payload: element
        );

        cache.putIfAbsent(event.id, () => event);
      }
    }

    return cache;
  }

  Future<GuildScheduledEvent?> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/guilds/${guild.id}/scheduled-events/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final GuildScheduledEvent event = GuildScheduledEvent.from(
          channelManager: guild.channels,
          memberManager: guild.members,
          payload: payload
      );

      cache.putIfAbsent(event.id, () => event);
      return event;
    }

    return null;
  }
}
