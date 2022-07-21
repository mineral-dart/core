import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class MessageManager implements FetchableCacheManager<PartialMessage> {
  @override
  Map<Snowflake, PartialMessage> cache = {};

  Snowflake? guildId;
  final Snowflake _channelId;

  MessageManager(this._channelId, this.guildId);

  @override
  Future<Map<Snowflake, PartialMessage>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/channels/$_channelId/messages");

    if(response.statusCode == 200) {
      cache.clear();
      dynamic payload = jsonDecode(response.body);

      for(dynamic element in payload) {
        _load(element);
      }
    }

    return cache;
  }

  @override
  Future<Message?> fetch (Snowflake id) async {
    print('fetched');
    if(cache.containsKey(id)) Console.warn(message: '$id already exist on cache, please avoid the usage of fetch method!');

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/channels/$_channelId/messages/$id");

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      return _load(payload, replace: true);
    }
    return null;
  }

  Message? _load(dynamic payload, {bool? replace}) {
    MineralClient client = ioc.singleton(ioc.services.client);
    Guild? guild = client.guilds.cache.get(guildId);
    TextBasedChannel? channel = guild?.channels.cache.get(_channelId);
    // @Todo add DM case (guild not exist)
    Message message = Message.from(channel: channel!, payload: payload);

    if(replace != null && replace && cache.containsKey(message.id)) {
      cache.update(message.id, (old) => old = message);
    } else {
      cache.putIfAbsent(message.id, () => message);
    }
    return message;
  }
}
