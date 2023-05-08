import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class DmChannelManager extends CacheManager<DmChannel> {
  Future<DmChannel> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: '/channels/$id')
      .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final DmChannel? channel = ChannelWrapper.create(payload);

      if (channel != null) {
        cache.putIfAbsent(channel.id, () => channel);
        return channel;
      }
    }

    throw ApiException('Unable to fetch channel with id #$id');
  }
}
