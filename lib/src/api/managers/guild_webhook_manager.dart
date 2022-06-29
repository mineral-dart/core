import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/webhook.dart';

class GuildWebhookManager implements CacheManager<Webhook> {
  @override
  Map<Snowflake, Webhook> cache = Map();

  Snowflake guildId;
  Guild? guild;

  GuildWebhookManager({ required this.guildId });

  @override
  Future<Map<Snowflake, Webhook>> sync () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.get(url: "/guilds/$guildId/webhooks");

    for (dynamic element in jsonDecode(response.body)) {
      Webhook webhook = Webhook.from(payload: element);
      cache.set(webhook.id, webhook);
    }

    return cache;
  }

  factory GuildWebhookManager.fromManager({ required WebhookManager webhookManager }) {
    GuildWebhookManager guildWebhookManager = GuildWebhookManager(guildId: webhookManager.guildId!);
    guildWebhookManager.cache = webhookManager.cache;

    return guildWebhookManager;
  }
}
