import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/server_serializer.dart';
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
  group('ServerSerializer', () {
    late ServerSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = ServerSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'id': '987654321',
          'name': 'Test Server',
          'description': 'A test server',
          'application_id': null,
          'owner_id': '444555666',
          'icon': null,
          'splash': null,
          'banner': null,
          'discovery_splash': null,
          'permissions': null,
          'afk_timeout': 300,
          'widget_enabled': false,
          'vanity_url_code': null,
          'max_video_channel_users': 25,
          'settings': {
            'explicit_content_filter': 0,
            'verification_level': 1,
            'default_message_notifications': 0,
            'features': ['COMMUNITY'],
            'mfa_level': 0,
            'system_channel_flags': 0,
            'premium_tier': 0,
            'premium_subscription_count': 0,
            'premium_progress_bar_enabled': false,
            'preferred_locale': 'en-US',
            'nsfw_level': 0,
          },
          'channel_settings': {
            'afk_channel_id': null,
            'system_channel_id': '111222333',
            'rules_channel_id': null,
            'public_updates_channel_id': null,
            'safety_alerts_channel_id': null,
          },
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'id': '987654321',
          'name': 'Test Server',
          'description': 'A test server',
          'application_id': null,
          'owner_id': '444555666',
          'icon': null,
          'icon_hash': null,
          'splash': null,
          'discovery_splash': null,
          'banner': null,
          'permissions': null,
          'afk_timeout': 300,
          'widget_enabled': false,
          'explicit_content_filter': 0,
          'verification_level': 1,
          'default_message_notifications': 0,
          'features': ['COMMUNITY'],
          'mfa_level': 0,
          'system_channel_flags': 0,
          'vanity_url_code': null,
          'premium_tier': 0,
          'premium_subscription_count': 0,
          'premium_progress_bar_enabled': false,
          'preferred_locale': 'en-US',
          'max_video_channel_users': 25,
          'nsfw_level': 0,
          'afk_channel_id': null,
          'system_channel_id': '111222333',
          'rules_channel_id': null,
          'public_updates_channel_id': null,
          'safety_alerts_channel_id': null,
        };

    group('serialize()', () {
      test('maps scalar fields correctly', () async {
        final server = await serializer.serialize(normalizedPayload());

        expect(server, isA<Server>());
        expect(server.id, equals(Snowflake('987654321')));
        expect(server.name, equals('Test Server'));
        expect(server.description, equals('A test server'));
        expect(server.ownerId, equals(Snowflake('444555666')));
      });

      test('builds ServerSettings with enums', () async {
        final server = await serializer.serialize(normalizedPayload());

        expect(server.settings.features, contains('COMMUNITY'));
        expect(server.settings.preferredLocale, equals('en-US'));
      });

      test('builds ChannelManager from channel_settings', () async {
        final server = await serializer.serialize(normalizedPayload());

        expect(server.channels.systemChannelId, equals(Snowflake('111222333')));
        expect(server.channels.afkChannelId, isNull);
        expect(server.channels.rulesChannelId, isNull);
      });
    });

    group('deserialize()', () {
      test('produces map with expected top-level keys', () async {
        final server = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(server);

        expect(result['id'], equals(Snowflake('987654321')));
        expect(result['name'], equals('Test Server'));
        expect(result['description'], equals('A test server'));
        expect(result['owner_id'], equals(Snowflake('444555666')));
      });

      test('produces settings sub-map', () async {
        final server = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(server);

        expect(result['settings'], isA<Map>());
        expect(result['settings']['features'], contains('COMMUNITY'));
        expect(result['settings']['preferred_locale'], equals('en-US'));
      });

      test('produces channel_settings sub-map', () async {
        final server = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(server);

        expect(result['channel_settings'], isA<Map>());
        expect(result['channel_settings']['system_channel_id'],
            equals('111222333'));
      });

      test('produces assets sub-map', () async {
        final server = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(server);

        expect(result['assets'], isA<Map>());
      });
    });

    group('normalize()', () {
      test('writes to cache with server key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().server('987654321');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('groups settings into sub-map', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['settings'], isA<Map>());
        expect(result['settings']['explicit_content_filter'], equals(0));
        expect(result['settings']['verification_level'], equals(1));
        expect(result['settings']['features'], contains('COMMUNITY'));
      });

      test('groups channel_settings into sub-map', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['channel_settings'], isA<Map>());
        expect(result['channel_settings']['system_channel_id'],
            equals('111222333'));
      });

      test('groups assets into sub-map', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['assets'], isA<Map>());
        expect(result['assets']['icon'], isNull);
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () async {
        final json = normalizedPayload();
        final server = await serializer.serialize(json);
        final result = await serializer.deserialize(server);

        expect(result['name'], equals(json['name']));
        expect(result['description'], equals(json['description']));
      });
    });
  });
}
