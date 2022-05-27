import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/sticker.dart';

class StickerManager implements CacheManager<Sticker> {
  @override
  Collection<Snowflake, Sticker> cache = Collection();

  Snowflake? guildId;
  late Guild? guild;

  StickerManager({ required this.guildId });

  Future<Sticker?> create ({ required String name, required String description, required String tags, required String filename }) async {
    if (guild!.features.contains(Feature.verified) || guild!.features.contains(Feature.partnered)) {
      Http http = ioc.singleton(Service.http);
      Response response = await http.post(url: "/guilds/$guildId/stickers", payload: {
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
      message: "${guild?.name} guild does not have the ${Feature.verified} or ${Feature.partnered} feature."
    );
    return null;
  }

  @override
  Future<Collection<Snowflake, Sticker>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get(url: "/guilds/$guildId/stickers");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Sticker sticker = Sticker.from(element);

      cache.putIfAbsent(sticker.id, () => sticker);
    }

    return cache;
  }
}
