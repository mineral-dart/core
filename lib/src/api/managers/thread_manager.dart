
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

import 'package:mineral/core.dart';

import '../channels/public_thread.dart';

class ThreadManager extends CacheManager<Channel> {

  @override
  Map<Snowflake, Channel> cache = {};

  Snowflake? guildId;
  late Guild? guild;
  late TextBasedChannel? channel;

  ThreadManager({ required this.guildId });

  @override
  Future<Map<Snowflake, Channel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$guildId/threads/active");
    dynamic payload = jsonDecode(response.body);

    for (dynamic element in payload) {
      if (element['type'] == ChannelType.guildPublicThread) {
        PublicThread thread = PublicThread.from(payload: element);

        cache.putIfAbsent(thread.id, () => thread);
      }
      if (element['type'] == ChannelType.guildPrivateThread) {
        //TODO
      }
    }

    return cache;
  }

  Future<PublicThread?> createPublicThread ({ required String label, }) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.post(url: "/channels/${channel?.id}/threads", payload: {
      'name': label,
      'auto_archive_duration': '60',
      'type': 11
    });
    print(response.body);
    if (response.statusCode == 200) {
      PublicThread thread = PublicThread.from(payload: jsonDecode(response.body));
      return thread;
    }

    if (response.statusCode == 400) {
      // TODO
    }
  }

}
