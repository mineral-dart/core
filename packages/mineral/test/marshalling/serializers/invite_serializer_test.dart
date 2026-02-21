import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/invite.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/invite_serializer.dart';
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
  group('InviteSerializer', () {
    late InviteSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = InviteSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'channelId': '111222333',
          'code': 'abc123',
          'createdAt': '2024-01-15T10:30:00.000Z',
          'expiresAt': '2024-01-16T10:30:00.000Z',
          'serverId': '987654321',
          'inviterId': '444555666',
          'maxAge': 86400,
          'maxUses': 10,
          'temporary': false,
          'type': 0,
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'channel_id': '111222333',
          'code': 'abc123',
          'created_at': '2024-01-15T10:30:00.000Z',
          'expires_at': '2024-01-16T10:30:00.000Z',
          'guild_id': '987654321',
          'inviter': {'id': '444555666'},
          'max_age': 86400,
          'max_uses': 10,
          'temporary': false,
          'type': 0,
        };

    group('serialize()', () {
      test('maps all fields correctly', () async {
        final invite = await serializer.serialize(normalizedPayload());

        expect(invite, isA<Invite>());
        expect(invite.code, equals('abc123'));
        expect(invite.type, equals(InviteType.server));
        expect(invite.channelId, equals(Snowflake('111222333')));
        expect(invite.serverId, equals(Snowflake('987654321')));
        expect(invite.inviterId, equals(Snowflake('444555666')));
        expect(invite.maxAge, equals(Duration(seconds: 86400)));
        expect(invite.maxUses, equals(10));
        expect(invite.isTemporary, isFalse);
        expect(invite.createdAt,
            equals(DateTime.parse('2024-01-15T10:30:00.000Z')));
      });

      test('handles nullable expiresAt', () async {
        final payload = normalizedPayload()..['expiresAt'] = null;
        final invite = await serializer.serialize(payload);

        expect(invite.expiresAt, isNull);
      });

      test('parses expiresAt when present', () async {
        final invite = await serializer.serialize(normalizedPayload());

        expect(invite.expiresAt, isA<DateTime>());
        expect(invite.expiresAt,
            equals(DateTime.parse('2024-01-16T10:30:00.000Z')));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () async {
        final invite = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(invite);

        expect(result['code'], equals('abc123'));
        expect(result['type'], equals(InviteType.server.value));
        expect(result['maxAge'], equals(86400));
        expect(result['maxUses'], equals(10));
        expect(result['temporary'], isFalse);
      });
    });

    group('normalize()', () {
      // Anomaly: normalize uses cacheKey.voiceState() instead of cacheKey.invite()
      test('writes to cache', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().voiceState('987654321', '444555666');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('renames Discord keys to internal keys', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['channelId'], equals('111222333'));
        expect(result['serverId'], equals('987654321'));
        expect(result['inviterId'], equals('444555666'));
        expect(result['code'], equals('abc123'));
        expect(result['maxAge'], equals(86400));
        expect(result['maxUses'], equals(10));
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () async {
        final json = normalizedPayload();
        final invite = await serializer.serialize(json);
        final result = serializer.deserialize(invite);

        expect(result['code'], equals(json['code']));
        expect(result['maxUses'], equals(json['maxUses']));
        expect(result['temporary'], equals(json['temporary']));
        expect(result['type'], equals(json['type']));
      });
    });
  });
}
