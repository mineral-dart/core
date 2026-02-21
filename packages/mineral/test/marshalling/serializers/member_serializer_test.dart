import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/permissions.dart';
import 'package:mineral/src/api/common/premium_tier.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/member_serializer.dart';
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
  group('MemberSerializer', () {
    late MemberSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = MemberSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'id': '444555666',
          'username': 'testuser',
          'nick': null,
          'global_name': 'TestUser',
          'discriminator': '0',
          'assets': {
            'server_id': '987654321',
            'member_id': '444555666',
            'avatar': null,
            'avatar_decoration': null,
            'banner': null,
          },
          'flags': 0,
          'roles': ['111222333'],
          'premium_since': null,
          'public_flags': 64,
          'is_bot': false,
          'is_pending': false,
          'timeout': null,
          'mfa_enabled': false,
          'locale': 'en-US',
          'premium_type': null,
          'joined_at': '2024-01-15T10:30:00.000Z',
          'permissions': '8',
          'accent_color': null,
          'server_id': '987654321',
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'user': {
            'id': '444555666',
            'username': 'testuser',
            'global_name': 'TestUser',
            'discriminator': '0',
            'avatar': null,
            'avatar_decoration_data': null,
            'public_flags': 64,
            'bot': false,
            'mfa_enabled': false,
            'locale': 'en-US',
            'premium_type': null,
          },
          'nick': null,
          'banner': null,
          'flags': 0,
          'roles': ['111222333'],
          'premium_since': null,
          'pending': false,
          'communication_disabled_until': null,
          'joined_at': '2024-01-15T10:30:00.000Z',
          'permissions': '8',
          'accent_color': null,
          'guild_id': '987654321',
        };

    group('serialize()', () {
      test('maps all scalar fields correctly', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member, isA<Member>());
        expect(member.id, equals(Snowflake('444555666')));
        expect(member.username, equals('testuser'));
        expect(member.globalName, equals('TestUser'));
        expect(member.discriminator, equals('0'));
        expect(member.isBot, isFalse);
        expect(member.isPending, isFalse);
        expect(member.mfaEnabled, isFalse);
        expect(member.locale, equals('en-US'));
        expect(member.publicFlags, equals(64));
        expect(member.serverId, equals(Snowflake('987654321')));
      });

      test('parses permissions from String', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.permissions, isA<Permissions>());
        expect(member.permissions.raw, equals(8));
      });

      test('defaults permissions to 0 when null', () async {
        final payload = normalizedPayload()..['permissions'] = null;
        final member = await serializer.serialize(payload);

        expect(member.permissions.raw, equals(0));
      });

      test('builds MemberRoleManager with role IDs', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.roles.currentIds, hasLength(1));
        expect(member.roles.currentIds.first, equals(Snowflake('111222333')));
      });

      test('handles null timeout', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.timeout.isTimeout, isFalse);
        expect(member.timeout.duration, isNull);
      });

      test('parses joinedAt datetime', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.joinedAt, isA<DateTime>());
        expect(member.joinedAt,
            equals(DateTime.parse('2024-01-15T10:30:00.000Z')));
      });

      test('defaults premiumType to none when null', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.premiumType, equals(PremiumTier.none));
      });

      test('builds MemberAssets with null values when absent', () async {
        final member = await serializer.serialize(normalizedPayload());

        expect(member.assets.avatar, isNull);
        expect(member.assets.avatarDecoration, isNull);
        expect(member.assets.banner, isNull);
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () async {
        final member = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(member);

        expect(result['id'], equals('444555666'));
        expect(result['username'], equals('testuser'));
        expect(result['is_bot'], isFalse);
        expect(result['is_pending'], isFalse);
        expect(result['locale'], equals('en-US'));
        expect(result['server_id'], equals('987654321'));
      });

      test('roles are serialized as list of Snowflake values', () async {
        final member = await serializer.serialize(normalizedPayload());
        final result = await serializer.deserialize(member);

        expect(result['roles'], isA<List>());
        expect(result['roles'], contains('111222333'));
      });
    });

    group('normalize()', () {
      test('writes to cache with member key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().member('987654321', '444555666');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('extracts user fields from nested user object', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['id'], equals('444555666'));
        expect(result['username'], equals('testuser'));
        expect(result['global_name'], equals('TestUser'));
        expect(result['discriminator'], equals('0'));
        expect(result['is_bot'], isFalse);
      });

      test('renames guild_id to server_id', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('server_id', '987654321'));
        expect(result.containsKey('guild_id'), isFalse);
      });

      test('builds assets sub-map', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['assets'], isA<Map>());
        expect(result['assets']['server_id'], equals('987654321'));
        expect(result['assets']['member_id'], equals('444555666'));
      });

      test('renames nick to nickname field', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('nickname', null));
      });

      test('preserves roles list', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['roles'], isA<List>());
        expect(result['roles'], contains('111222333'));
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () async {
        final json = normalizedPayload();
        final member = await serializer.serialize(json);
        final result = await serializer.deserialize(member);

        expect(result['username'], equals('testuser'));
        expect(result['is_bot'], equals(json['is_bot']));
        expect(result['locale'], equals(json['locale']));
        expect(result['server_id'], equals(Snowflake('987654321').value));
      });
    });
  });
}
