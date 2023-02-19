import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

import '../../../exception.dart';

class WebhookManager extends CacheManager<Webhook>  {
  final Snowflake? _channelId;
  final Snowflake? _guildId;

  WebhookManager(this._guildId, this._channelId);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, Webhook>> sync () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/channels/$_channelId/webhooks")
      .build();

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  Future<Webhook?> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/channels/$_channelId/webhooks/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final Webhook webhook = Webhook.from(payload: payload);

      cache.putIfAbsent(webhook.id, () => webhook);
      return webhook;
    }

    return null;
  }

  Future<Webhook?> create ({ required String label, String? avatar }) async {
    Response response = await ioc.use<DiscordApiHttpService>().post(url: "/channels/$_channelId/webhooks")
      .payload({ 'name': label, 'avatar': avatar != null ? await Helper.getPicture(avatar) : null })
      .build();

    return response.statusCode == 200
      ? Webhook.from(payload: jsonDecode(response.body))
      : null;
  }
}
