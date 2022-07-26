import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class ModerationRuleManager extends CacheManager<ModerationRule> {
  late final Guild guild;

  Future<ModerationRule?> create ({ required String label, required ModerationEventType eventType, required ModerationTriggerType triggerType, ModerationTriggerMetadata? triggerMetadata, List<ModerationAction>? actions, bool? enabled, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels }) async {
    Http http = ioc.singleton(ioc.services.http);

    /**
     * @Todo Add contraints
     * https://discord.com/developers/docs/resources/auto-moderation#auto-moderation-rule-object-trigger-types
     */
    Response response = await http.post(url: "/guilds/${guild.id}/auto-moderation/rules", payload: {
      'name': label,
      'event_type': eventType.value,
      'trigger_type': triggerType.value,
      'trigger_metadata': triggerMetadata?.toJson(),
      'actions': actions != null ? actions.map((action) => action.toJson()).toList() : [],
      'enabled': enabled ?? false,
      'exempt_roles': exemptRoles,
      'exempt_channels': exemptChannels,
    });

    if (response.statusCode == 200) {
      Object payload = jsonDecode(response.body);

      return ModerationRule.from(guild: guild, payload: payload);
    }
    return null;
  }
}
