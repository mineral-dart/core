import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageManager<T extends PartialMessage> extends CacheManager<T>  {
  final Snowflake? _guildId;
  final Snowflake _channelId;

  MessageManager(this._guildId, this._channelId);

  Future<Map<Snowflake, T>> fetch () async {
    cache.clear();

    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/channels/$_channelId/messages")
      .build();

    dynamic payload = jsonDecode(response.body);

    for (final element in payload) {
      if (_guildId != null) {
        final Guild guild = ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);
        Message message = Message.from(
          channel: guild.channels.cache.getOrFail(_channelId),
          payload: element
        );

        cache.putIfAbsent(message.id, () => message as T);
      } else {
        // @Todo add DM case
      }
    }

    return cache;
  }
}
