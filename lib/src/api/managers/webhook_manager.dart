import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class WebhookManager extends CacheManager<Webhook> {
  late final Channel? channel;
  late final Guild? guild;

  WebhookManager();

  Future<Map<Snowflake, Webhook>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/channels/${channel?.id}/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  Future<Webhook?> create ({ required String label, String? avatar }) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.post(url: "/channels/${channel?.id}/webhooks", payload: {
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
