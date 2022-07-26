import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/sticker.dart';

class StickerManager extends CacheManager<Sticker> {
  late final Guild guild;

  Future<Sticker?> create ({ required String name, required String description, required String tags, required String filename }) async {
    if (guild.features.contains(GuildFeature.verified) || guild.features.contains(GuildFeature.partnered)) {
      Http http = ioc.singleton(ioc.services.http);
      Response response = await http.post(url: "/guilds/${guild.id}/stickers", payload: {
        'name': name,
        'description': description,
        'tags': tags,
        'file': Helper.getPicture(filename)
      });

      dynamic payload = jsonDecode(response.body);

      Sticker sticker = Sticker.from(payload);
      sticker.manager = this;

      cache.putIfAbsent(sticker.id, () => sticker);

      return sticker;
    }

    Console.warn(
      prefix: 'cancelled',
      message: "${guild.name} guild does not have the ${GuildFeature.verified} or ${GuildFeature.partnered} feature."
    );
    return null;
  }

  Future<Map<Snowflake, Sticker>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/${guild.id}/stickers");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Sticker sticker = Sticker.from(element);

      cache.putIfAbsent(sticker.id, () => sticker);
    }

    return cache;
  }
}
