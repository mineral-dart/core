import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class EmojiManager implements CacheManager<Emoji> {
  @override
  Collection<Snowflake, Emoji> cache = Collection();

  Snowflake? guildId;
  late Guild? guild;

  EmojiManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, Emoji>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get("/guilds/$guildId/emojis");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Emoji emoji = Emoji.from(
        memberManager: guild!.members,
        roleManager: guild!.roles,
        payload: element
      );

      cache.putIfAbsent(emoji.id, () => emoji);
    }

    return cache;
  }
}
