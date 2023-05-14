import 'dart:convert';

import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class GuildManager extends CacheManager<Guild> {
  Future<Guild> create (GuildBuilder builder) async {
    final clientId = ioc.use<MineralClient>().user.id;
    if (cache.values.fold(0, (previousValue, element) => previousValue += element.owner.id == clientId ? 1 : 0) >= 10) {
      throw Exception('You can\'t create more than 10 guilds');
    }

    print(jsonEncode(builder.toJson));
    final response = await ioc.use<DiscordApiHttpService>()
      .post(url: '/guilds')
      .payload(builder.toJson)
      .build();

    final Map<String, dynamic> payload = jsonDecode(response.body);

    return ioc.use<MineralClient>().guilds.cache.getOrFail(payload['id']);
  }
}
