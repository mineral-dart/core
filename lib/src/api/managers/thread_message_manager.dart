import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/public_thread.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ThreadMessageManager implements CacheManager<Channel> {

  @override
  Map<Snowflake, Channel> cache = {};

  Snowflake? guildId;
  late Guild? guild;
  late TextBasedChannel? channel;
  late Snowflake? message;

  ThreadMessageManager({ required this.guildId });

  @override
  Future<Map<Snowflake, Channel>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$guildId/threads/active");
    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      for (dynamic element in payload) {
        if (element['type'] == ChannelType.guildPublicThread) {
          PublicThread thread = PublicThread.from(payload: element);
          cache.putIfAbsent(thread.id, () => thread);
        }
      }
    }
    return cache;
  }

  Future<PublicThread?> startPublicThread ({ required String label }) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.post(url: "/channels/${channel?.id}/messages/$message/threads", payload: {
      'name': label,
      'auto_archive_duration': '60',
    });

    if (response.statusCode == 200) {
      PublicThread thread = PublicThread.from(payload: jsonDecode(response.body));
      return thread;
    }
    return null;
  }
}