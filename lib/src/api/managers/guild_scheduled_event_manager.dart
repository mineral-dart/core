import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildScheduledEventManager implements CacheManager<GuildScheduledEvent> {
  @override
  Map<Snowflake, GuildScheduledEvent> cache = {};

  Snowflake? guildId;
  late Guild guild;

  GuildScheduledEventManager({required this.guildId});

  @override
  Future<Map<Snowflake, GuildScheduledEvent>> sync() async {
    final Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/guilds/$guildId/scheduled-events");
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
}
