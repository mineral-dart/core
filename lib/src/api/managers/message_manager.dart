import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class MessageManager extends CacheManager<PartialMessage> {
  late final TextBasedChannel channel;

  Future<Map<Snowflake, PartialMessage>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/channels/${channel.id}/messages");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      // @Todo add DM case (guild not exist)
      Message message = Message.from(channel: channel, payload: element);
      cache.putIfAbsent(message.id, () => message);
    }

    return cache;
  }
}
