import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

class EmojiManager extends CacheManager<Emoji>  {
  late final Guild guild;

  Future<Map<Snowflake, Emoji>> sync () async {
    cache.clear();

    Response response = await ioc.use<HttpService>().get(url: "/guilds/${guild.id}/emojis");
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
     throw EmptyParameterException('Parameter "path" cannot be null or empty');
    }

    String image = await Helper.getPicture(path);

    Response response = await ioc.use<HttpService>().post(url: "/guilds/${guild.id}/emojis", payload: {
      'name': label,
      'image': image,
      'roles': roles ?? [],
    });

    Emoji emoji = Emoji.from(
      memberManager: guild.members,
      emojiManager: this,
      payload: jsonDecode(response.body),
    );

    cache.putIfAbsent(emoji.id, () => emoji);

    return emoji;
  }
}
