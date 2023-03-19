import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class ModerationRuleManager extends CacheManager<ModerationRule>  {
  final Snowflake _guildId;

  ModerationRuleManager(this._guildId);

  /// Create new moderation rule from [builder]
  /// ```dart
  /// await guild.moderationRules.create(
  ///   ModerationRulesBuilder.mentionSpam(
  ///     label: 'Test',
  ///     enabled: true,
  ///     triggerMetadata: ModerationTriggerMetadata.mentions(maxMentions: 4),
  ///     actions: [
  ///       ModerationAction.sendAlert('1021156085559726221'),
  ///       ModerationAction.blockMessage(),
  ///       ModerationAction.timeout(Duration(seconds: 5)),
  ///     ]
  ///   )
  /// );
  /// ```
  Future<ModerationRule?> create (ModerationRulesBuilder builder) async {
    Response response = await ioc.use<DiscordApiHttpService>().post(url: "/guilds/$_guildId/auto-moderation/rules")
      .payload({
        'name': builder.label,
        'event_type': builder.moderationEventType.value,
        'trigger_type': builder.moderationTriggerType.value,
        'trigger_metadata': builder.triggerMetadata?.toJson(),
        'actions': builder.actions.map((action) => action.toJson()).toList(),
        'enabled': builder.enabled,
        'exempt_roles': builder.exemptRoles,
        'exempt_channels': builder.exemptChannels,
      }).build();

    return response.statusCode == 200
      ? ModerationRule.fromPayload(jsonDecode(response.body))
      : null;
  }

  /// Get guild moderation rules from Discord API
  /// ```dart
  /// final rules = await guild.moderationRules.sync();
  /// ```
  Future<Map<Snowflake, ModerationRule>> sync () async {
    Response response = await ioc.use<DiscordApiHttpService>()
      .get(url: "/guilds/$_guildId/auto-moderation/rules")
      .build();

    for (final payload in jsonDecode(response.body)) {
      final ModerationRule rule = ModerationRule.fromPayload(payload);
      cache.putIfAbsent(rule.id, () => rule);
    }

    return cache;
  }

  Future<ModerationRule> resolve (Snowflake id) async {
    if(cache.containsKey(id)) {
      return cache.getOrFail(id);
    }

    final Response response = await ioc.use<DiscordApiHttpService>()
        .get(url: '/guilds/$_guildId/auto-moderation/rules/$id')
        .build();

    if(response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);
      final ModerationRule rule = ModerationRule.fromPayload(payload);

      cache.putIfAbsent(rule.id, () => rule);
      return rule;
    }

    throw ApiException('Unable to fetch moderation rule with id #$id');
  }

}
