import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/webhook.dart';

class WebhookManager implements CacheManager<Webhook> {
  @override
  Collection<Snowflake, Webhook> cache = Collection();

  Snowflake? channelId;
  Snowflake? guildId;
  late Guild? guild;

  WebhookManager({ this.channelId, required this.guildId });

  @override
  Future<Collection<Snowflake, Webhook>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/channels/$channelId/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  Future<Webhook?> create ({ required String label, String? avatar }) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.post(url: "/channels/$channelId/webhooks", payload: {
      'name': label,
      'avatar': avatar != null ? await Helper.getPicture(avatar) : null
    });

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      Webhook webhook = Webhook.from(payload: payload);
      webhook.channel = guild?.channels.cache.get(payload['guild_id']);
      webhook.user = guild?.members.cache.get(payload['user']['id']);
      webhook.guild = guild;

      return webhook;
    }
    return null;
  }
}
