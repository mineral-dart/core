

import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ThreadManager implements CacheManager<Channel> {
  
  @override
  Collection<Snowflake, Channel> cache = Collection();
  
  Snowflake? guildId;
  late Guild? guild;
  
  ThreadManager({ required this.guildId});
  
  @override
  Future<Collection<Snowflake, Channel>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();
    
    Response response = await http.get("/guilds/$guildId/threads/active");
    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      if (element['type'] == ChannelType.guildPublicThread) {
        PublicThread thread = PublicThread.from(element);

        cache.putIfAbsent(thread.id, () => thread);
      }
      if (element['type'] == ChannelType.guildPrivateThread) {
        //TODO
      }
    }

    return cache;
  }
}