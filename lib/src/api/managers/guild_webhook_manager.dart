import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class GuildWebhookManager extends CacheManager<Webhook> with Container {
  late final Guild guild;

  GuildWebhookManager();

  Future<Map<Snowflake, Webhook>> sync () async {
    Response response = await container.use<Http>().get(url: "/guilds/${guild.id}/webhooks");

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
