import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/server/moderation/enums/auto_moderation_event_type.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';
import 'package:mineral/src/api/server/moderation/trigger_metadata.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class RulesPart implements RulesPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, AutoModerationRule>> fetch(
      Object serverId, bool force) async {
    final completer = Completer<Map<Snowflake, AutoModerationRule>>();

    final req =
        Request.json(endpoint: '/guilds/$serverId/auto-moderation/rules');
    final result = await _dataStore.requestBucket
        .query<List<dynamic>>(req)
        .run(_dataStore.client.get);

    final rules = await result.map((element) async {
      final raw = await _marshaller.serializers.rules.normalize(element);
      return _marshaller.serializers.rules.serialize(raw);
    }).wait;

    completer
        .complete(rules.asMap().map((_, value) => MapEntry(value.id!, value)));

    return completer.future;
  }

  @override
  Future<AutoModerationRule?> get(
      Object serverId, Object rulesId, bool force) async {
    final completer = Completer<AutoModerationRule>();
    final String key = _marshaller.cacheKey.serverRules(serverId, rulesId);

    final cachedEmoji = await _marshaller.cache?.get(key);
    if (!force && cachedEmoji != null) {
      final rule = await _marshaller.serializers.rules.serialize(cachedEmoji);
      completer.complete(rule);

      return completer.future;
    }

    final req = Request.json(
        endpoint: '/guilds/$serverId/auto-moderation/rules/$rulesId');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.rules.normalize(result);
    final rule = await _marshaller.serializers.rules.serialize(raw);

    completer.complete(rule);

    return completer.future;
  }

  @override
  Future<AutoModerationRule> create({
    required Object serverId,
    required String name,
    required AutoModerationEventType eventType,
    required TriggerType triggerType,
    required List<Action> actions,
    TriggerMetadata? triggerMetadata,
    List<Snowflake> exemptRoles = const [],
    List<Snowflake> exemptChannels = const [],
    bool isEnabled = true,
    String? reason,
  }) async {
    final completer = Completer<AutoModerationRule>();

    final req = Request.json(
        endpoint: '/guilds/$serverId/auto-moderation/rules',
        body: {
          'name': name,
          'event_type': eventType.value,
          'trigger_type': triggerType.value,
          'trigger_metadata': triggerMetadata != null
              ? {
                  'keyword_filter': triggerMetadata.keywordFilter,
                  'regex_patterns': triggerMetadata.regexPatterns,
                  'presets':
                      triggerMetadata.presets.map((e) => e.value).toList(),
                  'allow_list': triggerMetadata.allowList,
                  'mention_total_limit': triggerMetadata.mentionTotalLimit,
                  'mention_raid_protection_enabled':
                      triggerMetadata.mentionRaidProtectionEnabled,
                }
              : null,
          'actions': actions
              .map((action) => {
                    'type': action.type.value,
                    if (action.metadata != null) 'metadata': action.metadata,
                  })
              .toList(),
          'exempt_roles': exemptRoles.map((e) => e.toString()).toList(),
          'exempt_channels': exemptChannels.map((e) => e.toString()).toList(),
          'enabled': isEnabled,
        },
        headers: {
          DiscordHeader.auditLogReason(reason)
        });
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.post);

    final raw = await _marshaller.serializers.channels.normalize(result);
    final rule = await _marshaller.serializers.rules.serialize({
      ...raw,
      'guild_id': serverId,
    });

    completer.complete(rule);

    return completer.future;
  }

  @override
  Future<AutoModerationRule?> update(
      {required Object id,
      required Object serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final completer = Completer<AutoModerationRule>();

    final req = Request.json(
        endpoint: '/guilds/$serverId/auto-moderation/rules/$id',
        body: payload,
        headers: {DiscordHeader.auditLogReason(reason)});

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.patch);

    final raw = await _marshaller.serializers.rules.normalize({
      ...result,
      'guild_id': serverId,
    });
    final rule = await _marshaller.serializers.rules.serialize(raw);

    completer.complete(rule);
    return completer.future;
  }

  @override
  Future<void> delete(Object serverId, Object ruleId, {String? reason}) async {
    final req = Request.json(
        endpoint: '/guilds/$serverId/auto-moderation/rules/$ruleId',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
