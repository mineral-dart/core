import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class WebhookManager extends CacheManager<Webhook> with Container {
  final Snowflake? _channelId;
  final Snowflake? _guildId;

  WebhookManager(this._guildId, this._channelId);

  /// Get [Guild] from [Ioc]
  Guild get guild => container.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  Future<Map<Snowflake, Webhook>> sync () async {
    Response response = await container.use<HttpService>().get(url: "/channels/$_channelId/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  Future<Webhook?> create ({ required String label, String? avatar }) async {
    Response response = await container.use<HttpService>().post(url: "/channels/$_channelId/webhooks", payload: {
      'name': label,
      'avatar': avatar != null ? await Helper.getPicture(avatar) : null
    });

    return response.statusCode == 200
      ? Webhook.from(payload: jsonDecode(response.body))
      : null;
  }
}
