import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/guild.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/constants.dart';
import 'package:mineral/src/collection.dart';

class EmojiManager implements CacheManager<Emoji> {
  @override
  Collection<Snowflake, Emoji> cache = Collection();

  @override
  Snowflake guildId;

  @override
  late Guild guild;

  EmojiManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, Emoji>> sync () async {
    Http http = ioc.singleton('Mineral/Core/Http');
    cache.clear();

    Response response = await http.get("/guilds/$guildId/emojis");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Emoji emoji = Emoji.from(
        memberManager: guild.members,
        roleManager: guild.roles,
        payload: element
      );

      cache.putIfAbsent(emoji.id, () => emoji);
    }

    return cache;
  }
}
