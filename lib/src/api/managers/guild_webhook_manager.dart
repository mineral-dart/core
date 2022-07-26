import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';

class GuildWebhookManager extends CacheManager<Webhook> {
  late final Guild guild;

  GuildWebhookManager();

  Future<Map<Snowflake, Webhook>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/guilds/${guild.id}/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  factory GuildWebhookManager.fromManager({ required WebhookManager webhookManager }) {
    final guildWebhookManager = GuildWebhookManager();
    guildWebhookManager.cache.addAll(webhookManager.cache);

    return guildWebhookManager;
  }
}
