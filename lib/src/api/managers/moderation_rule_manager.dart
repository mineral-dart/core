import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ModerationRuleManager extends CacheManager<ModerationRule> {
  final Snowflake _guildId;

  ModerationRuleManager(this._guildId);

  Future<ModerationRule?> create (ModerationRulesBuilder builder) async {
    Http http = ioc.singleton(Service.http);

    /**
     * @Todo Add contraints
     * https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-trigger-types
     */
    Response response = await http.post(url: "/guilds/$_guildId/auto-moderation/rules", payload: {
      'name': builder.label,
      'event_type': builder.moderationEventType.value,
      'trigger_type': builder.moderationTriggerType.value,
      'trigger_metadata': builder.triggerMetadata?.toJson(),
      'actions': builder.actions.map((action) => action.toJson()).toList(),
      'enabled': builder.enabled,
      'exempt_roles': builder.exemptRoles,
      'exempt_channels': builder.exemptChannels,
    });

    if (response.statusCode == 200) {
      Object payload = jsonDecode(response.body);

      return ModerationRule.fromPayload(payload);
    }
    return null;
  }
}
