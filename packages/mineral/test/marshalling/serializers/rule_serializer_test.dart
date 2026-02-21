import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/moderation/auto_moderation_rule.dart';
import 'package:mineral/src/api/server/moderation/enums/action_type.dart';
import 'package:mineral/src/api/server/moderation/enums/auto_moderation_event_type.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/rule_serializer.dart';
import 'package:test/test.dart';

final class _FakeLogger implements LoggerContract {
  @override
  void trace(Object message) {}
  @override
  void fatal(Exception message) {}
  @override
  void error(String message) {}
  @override
  void warn(String message) {}
  @override
  void info(String message) {}
}

final class _FakeCacheProvider implements CacheProviderContract {
  final Map<String, dynamic> store = {};

  @override
  String get name => 'fake';
  @override
  FutureOr<void> init() {}
  @override
  FutureOr<int> length() => store.length;
  @override
  FutureOr<Map<String, dynamic>> inspect() => store;
  @override
  FutureOr<Map<String, dynamic>?> get(String? key) =>
      key != null ? store[key] as Map<String, dynamic>? : null;
  @override
  FutureOr<List<Map<String, dynamic>?>> getMany(List<String> keys) =>
      keys.map((k) => store[k] as Map<String, dynamic>?).toList();
  @override
  FutureOr<Map<String, dynamic>> getOrFail(String key,
          {Exception Function()? onFail}) =>
      store[key] as Map<String, dynamic>? ??
      (throw (onFail?.call() ?? Exception('Key $key not found')));
  @override
  FutureOr<Map<String, dynamic>?> whereKeyStartsWith(String prefix) =>
      store.entries
          .where((e) => e.key.startsWith(prefix))
          .map((e) => e.value as Map<String, dynamic>)
          .firstOrNull;
  @override
  FutureOr<Map<String, dynamic>> whereKeyStartsWithOrFail(String prefix,
          {Exception Function()? onFail}) =>
      whereKeyStartsWith(prefix) as Map<String, dynamic>? ??
      (throw (onFail?.call() ?? Exception('Prefix $prefix not found')));
  @override
  FutureOr<bool> has(String key) => store.containsKey(key);
  @override
  FutureOr<void> put<T>(String key, T object) => store[key] = object;
  @override
  FutureOr<void> putMany<T>(Map<String, T> object) {
    store.addAll(object);
  }

  @override
  FutureOr<void> remove(String key) {
    store.remove(key);
  }

  @override
  FutureOr<void> removeMany(List<String> key) {
    for (final k in key) {
      store.remove(k);
    }
  }

  @override
  FutureOr<void> clear() {
    store.clear();
  }

  @override
  FutureOr<void> dispose() {
    store.clear();
  }

  @override
  FutureOr<bool> getHealth() => true;
}

final class _FakeMarshaller implements MarshallerContract {
  @override
  final LoggerContract logger = _FakeLogger();
  @override
  final CacheProviderContract? cache;
  @override
  late final SerializerBucket serializers;
  @override
  final CacheKey cacheKey = CacheKey();

  _FakeMarshaller({this.cache}) {
    serializers = SerializerBucket(this);
  }
}

void main() {
  group('RuleSerializer', () {
    late RuleSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = RuleSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'id': '100200300',
          'serverId': '987654321',
          'name': 'No Profanity',
          'creatorId': '444555666',
          'eventType': 1,
          'triggerType': 1,
          'triggerMetadata': {
            'keyword_filter': ['badword'],
            'regex_patterns': <String>[],
            'presets': <int>[],
            'allow_list': <String>[],
            'mention_total_limit': null,
            'mention_raid_protection_enabled': null,
          },
          'actions': [
            {'type': 1},
          ],
          'enabled': true,
          'exemptRoles': ['111222333'],
          'exemptChannels': ['444555666'],
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'id': '100200300',
          'guild_id': '987654321',
          'name': 'No Profanity',
          'creator_id': '444555666',
          'event_type': 1,
          'trigger_type': 1,
          'trigger_metadata': {
            'keyword_filter': ['badword'],
            'regex_patterns': <String>[],
            'presets': <int>[],
            'allow_list': <String>[],
            'mention_total_limit': null,
            'mention_raid_protection_enabled': null,
          },
          'actions': [
            {'type': 1},
          ],
          'enabled': true,
          'exempt_roles': ['111222333'],
          'exempt_channels': ['444555666'],
        };

    group('serialize()', () {
      test('maps all fields correctly', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule, isA<AutoModerationRule>());
        expect(rule.id, equals(Snowflake('100200300')));
        expect(rule.serverId, equals(Snowflake('987654321')));
        expect(rule.name, equals('No Profanity'));
        expect(rule.creatorId, equals(Snowflake('444555666')));
        expect(rule.enabled, isTrue);
      });

      test('resolves AutoModerationEventType', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.eventTypes, equals(AutoModerationEventType.messageSend));
      });

      test('resolves TriggerType', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.triggerTypes, equals(TriggerType.keyword));
      });

      test('parses TriggerMetadata from sub-map', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.triggerMetadata.keywordFilter, contains('badword'));
        expect(rule.triggerMetadata.regexPatterns, isEmpty);
        expect(rule.triggerMetadata.presets, isEmpty);
      });

      test('parses actions list', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.action, hasLength(1));
        expect(rule.action.first.type, equals(ActionType.blockMessage));
      });

      test('parses exemptRoles as Snowflake list', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.exemptRoles, hasLength(1));
        expect(rule.exemptRoles.first, equals(Snowflake('111222333')));
      });

      test('parses exemptChannels as Snowflake list', () async {
        final rule = await serializer.serialize(normalizedPayload());

        expect(rule.exemptChannels, hasLength(1));
        expect(rule.exemptChannels.first, equals(Snowflake('444555666')));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () async {
        final rule = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(rule);

        expect(result['name'], equals('No Profanity'));
        expect(result['event_type'],
            equals(AutoModerationEventType.messageSend.value));
        expect(result['trigger_type'], equals(TriggerType.keyword.value));
        expect(result['enabled'], isTrue);
      });

      test('trigger_metadata is a sub-map with expected keys', () async {
        final rule = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(rule);

        expect(result['trigger_metadata'], isA<Map>());
        expect(
            result['trigger_metadata']['keyword_filter'], contains('badword'));
      });

      test('actions are serialized as list of maps', () async {
        final rule = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(rule);

        expect(result['actions'], isA<List>());
        expect(result['actions'], hasLength(1));
        expect(result['actions'].first['type'],
            equals(ActionType.blockMessage.value));
      });
    });

    group('normalize()', () {
      test('writes to cache with serverRules key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().serverRules('987654321', '100200300');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('renames guild_id to serverId', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('serverId', '987654321'));
        expect(result.containsKey('guild_id'), isFalse);
      });

      test('renames creator_id to creatorId', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('creatorId', '444555666'));
      });

      test('parses exempt_roles as Snowflake list', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['exemptRoles'], isA<List<Snowflake>>());
        expect(result['exemptRoles'], hasLength(1));
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () async {
        final json = normalizedPayload();
        final rule = await serializer.serialize(json);
        final result = serializer.deserialize(rule);

        expect(result['name'], equals(json['name']));
        expect(result['enabled'], equals(json['enabled']));
        expect(result['event_type'], equals(json['eventType']));
        expect(result['trigger_type'], equals(json['triggerType']));
      });
    });
  });
}
