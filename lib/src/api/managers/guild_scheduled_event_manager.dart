import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class GuildScheduledEventManager extends CacheManager<GuildScheduledEvent> with Container {
  late final Guild guild;

  Future<Map<Snowflake, GuildScheduledEvent>> sync() async {
    Response response = await container.use<Http>().get(url: "/guilds/${guild.id}/scheduled-events");
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
