import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/sticker.dart';

class StickerManager implements CacheManager<Sticker> {
  @override
  Collection<Snowflake, Sticker> cache = Collection();

  Snowflake? guildId;
  late Guild? guild;

  StickerManager({ required this.guildId });

  @override
  Future<Collection<Snowflake, Sticker>> sync () async {
    Http http = ioc.singleton(Service.http);
    cache.clear();

    Response response = await http.get("/guilds/$guildId/stickers");
    dynamic payload = jsonDecode(response.body);

    for(dynamic element in payload) {
      Sticker sticker = Sticker.from(element);

      cache.putIfAbsent(sticker.id, () => sticker);
    }

    return cache;
  }
}
