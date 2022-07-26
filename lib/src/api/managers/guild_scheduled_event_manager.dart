import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildScheduledEventManager extends CacheManager<GuildScheduledEvent> {
  late final Guild _guild;
  Guild get guild => _guild;

  Future<Map<Snowflake, GuildScheduledEvent>> sync() async {
    final Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/guilds/${_guild.id}/scheduled-events");
    if (response.statusCode == 200) {
      cache.clear();

      dynamic payload = jsonDecode(response.body);
      for (dynamic element in payload) {
        GuildScheduledEvent event = GuildScheduledEvent.from(
            channelManager: _guild.channels,
            memberManager: _guild.members,
            payload: element
        );

        cache.putIfAbsent(event.id, () => event);
      }
    }

    return cache;
  }
}
