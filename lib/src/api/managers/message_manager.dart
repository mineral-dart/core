import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class MessageManager implements CacheManager<Message> {
  @override
  Collection<Snowflake, Message> cache = Collection();

  final Snowflake? _guildId;
  final Snowflake _channelId;

  MessageManager(this._channelId, this._guildId);

  @override
  Future<Collection<Snowflake, Message>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get("/channels/$_channelId/messages");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      MineralClient client = ioc.singleton(Service.client);
      Guild? guild = client.guilds.cache.get(_guildId);
      TextBasedChannel? channel = guild?.channels.cache.get(_channelId);
      // @Todo add DM case (guild not exist)
      Message message = Message.from(channel: channel!, payload: element);
      cache.putIfAbsent(message.id, () => message);
    }

    return cache;
  }
}
