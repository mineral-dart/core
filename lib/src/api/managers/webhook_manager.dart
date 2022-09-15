import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class WebhookManager extends CacheManager<Webhook> {
  final Snowflake? _channelId;
  final Snowflake? _guildId;

  WebhookManager(this._guildId, this._channelId);

  /// Get [Guild] from [Ioc]
  Guild get guild => ioc.singleton<MineralClient>(Service.client).guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, Webhook>> sync () async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.get(url: "/channels/$_channelId/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  Future<Webhook?> create ({ required String label, String? avatar }) async {
    Http http = ioc.singleton(Service.http);
    Response response = await http.post(url: "/channels/$_channelId/webhooks", payload: {
      'name': label,
      'avatar': avatar != null ? await Helper.getPicture(avatar) : null
    });

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      Webhook webhook = Webhook.from(payload: payload);
      webhook..channel = guild.channels.cache.get(payload['guild_id'])
        ..user = guild.members.cache.get(payload['user']['id'])
        ..guild = guild;

      return webhook;
    }
    return null;
  }
}
