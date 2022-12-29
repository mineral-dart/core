import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class MessageManager<T extends PartialMessage> extends CacheManager<T>  {
  late final TextBasedChannel channel;

  Future<Map<Snowflake, T>> fetch () async {
    cache.clear();

    Response response = await ioc.use<HttpService>().get(url: "/channels/${channel.id}/messages");
    dynamic payload = jsonDecode(response.body);

    if (payload['guild_id'] == null) {
      // @Todo add DM case
    } else {
      for (final element in payload) {
        Message message = Message.from(channel: channel, payload: element);
        cache.putIfAbsent(message.id, () => message as T);
      }
    }

    return cache;
  }
}
