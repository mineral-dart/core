import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/moderation/enums/action_type.dart';
import 'package:mineral/src/api/server/moderation/enums/auto_moderation_event_type.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';
import 'package:mineral/src/api/server/moderation/trigger_metadata.dart';
import 'package:mineral/src/domains/common/utils/utils.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class RuleSerializer implements SerializerContract<AutoModerationRule> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'serverId': json['guild_id'],
      'name': json['name'],
      'creatorId': json['creator_id'],
      'eventType': json['event_type'],
      'triggerType': json['trigger_type'],
      'triggerMetadata': json['trigger_metadata'],
      'actions': json['actions'],
      'enabled': json['enabled'],
      'exemptRoles': List<Snowflake>.from(
          (json['exempt_roles'] as List).map(Snowflake.parse)),
      'exemptChannels': List<Snowflake>.from(
          (json['exempt_channels'] as List).map(Snowflake.parse)),
    };

    final cacheKey =
        _marshaller.cacheKey.serverRules(json['guild_id'], json['id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<AutoModerationRule> serialize(Map<String, dynamic> json) async {
    return AutoModerationRule(
      id: Snowflake.parse(json['id']),
      serverId: Snowflake.parse(json['serverId']),
      name: json['name'],
      creatorId: Snowflake.parse(json['creatorId']),
      eventTypes: findInEnum(AutoModerationEventType.values, json['eventType']),
      triggerMetadata: TriggerMetadata.fromJson(json['triggerMetadata']),
      action: (json['actions'] as List).map((action) {
        final type = findInEnum(ActionType.values, action['type']);
        return Action(type: type);
      }).toList(),
      isEnabled: json['enabled'] ?? true,
      exemptRoles: List<Snowflake>.from(
          (json['exemptRoles'] as List).map(Snowflake.parse)),
      exemptChannels: List<Snowflake>.from(
          (json['exemptChannels'] as List).map(Snowflake.parse)),
      triggerTypes: findInEnum(TriggerType.values, json['triggerType']),
    );
  }

  @override
  Map<String, dynamic> deserialize(AutoModerationRule rule) {
    return {
      'id': rule.id,
      'server_id': rule.serverId.toString(),
      'name': rule.name,
      'creator_id': rule.creatorId.toString(),
      'event_type': rule.eventTypes.value,
      'trigger_type': rule.triggerTypes.value,
      'trigger_metadata': {
        'keyword_filter': rule.triggerMetadata.keywordFilter,
        'regex_patterns': rule.triggerMetadata.regexPatterns,
        'presets': rule.triggerMetadata.presets.map((e) => e.value).toList(),
        'allow_list': rule.triggerMetadata.allowList,
        'mention_total_limit': rule.triggerMetadata.mentionTotalLimit,
        'mention_raid_protection_enabled':
            rule.triggerMetadata.mentionRaidProtectionEnabled,
      },
      'actions': rule.action
          .map((action) => {
                'type': action.type.value,
              })
          .toList(),
      'enabled': rule.isEnabled,
      'exempt_roles': rule.exemptRoles.map((e) => e.toString()).toList(),
      'exempt_channels': rule.exemptChannels.map((e) => e.toString()).toList(),
    };
  }
}
