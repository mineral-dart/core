import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class EmojiManager extends CacheManager<Emoji> {
  late final Guild guild;

  Future<Map<Snowflake, Emoji>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/${guild.id}/emojis");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Emoji emoji = Emoji.from(
        memberManager: guild.members,
        //roleManager: guild!.roles,
        emojiManager: this,
        payload: element
      );

      cache.putIfAbsent(emoji.id, () => emoji);
    }

    return cache;
  }

  Future<Emoji> create ({ required String label, required String path, List<Snowflake>? roles }) async {
    if (path.isEmpty) {
     throw EmptyParameterException(cause: 'Parameter "path" cannot be null or empty');
    }

    Http http = ioc.singleton(ioc.services.http);
    String image = await Helper.getPicture(path);

    Response response = await http.post(url: "/guilds/${guild.id}/emojis", payload: {
      'name': label,
      'image': image,
      'roles': roles ?? [],
    });

    Emoji emoji = Emoji.from(
      memberManager: guild.members,
      //roleManager: guild!.roles,
      emojiManager: this,
      payload: jsonDecode(response.body),
    );

    cache.putIfAbsent(emoji.id, () => emoji);

    return emoji;
  }
}
