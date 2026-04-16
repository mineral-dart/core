import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/invite_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/message_reaction_serializer.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/message_serializer.dart';
import 'package:test/test.dart';

import '../../helpers/fake_logger.dart';
import '../../helpers/ioc_test_helper.dart';

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
  final FakeLogger logger;
  @override
  final CacheProviderContract? cache;
  @override
  late final SerializerBucket serializers;
  @override
  final CacheKey cacheKey = CacheKey();

  _FakeMarshaller({required this.logger, this.cache}) {
    serializers = SerializerBucket(this);
  }
}

void main() {
  group('MessageSerializer edge cases', () {
    late MessageSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      final testIoc = createTestIoc();
      cache = _FakeCacheProvider();
      testIoc.container.bind<MarshallerContract>(
          () => _FakeMarshaller(logger: testIoc.logger, cache: cache));
      restoreIoc = testIoc.restore;
      serializer = MessageSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    group('normalize() with null author (webhook messages)', () {
      test('does not crash when author is null', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
          'content': 'webhook message',
          'embeds': <Map<String, dynamic>>[],
          'guild_id': '987654321',
          'author': null,
          'timestamp': '2024-06-01T12:00:00.000Z',
          'edited_timestamp': null,
        };

        final result = await serializer.normalize(payload);

        expect(result['id'], equals('111222333'));
        expect(result['channel_id'], equals('444555666'));
        expect(result['author_id'], isNull);
        expect(result['author_is_bot'], isNull);
      });

      test('still writes to cache when author is null', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
          'content': 'webhook message',
          'embeds': <Map<String, dynamic>>[],
          'guild_id': '987654321',
          'author': null,
          'timestamp': '2024-06-01T12:00:00.000Z',
          'edited_timestamp': null,
        };

        await serializer.normalize(payload);

        final expectedKey = CacheKey().message('444555666', '111222333');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });
    });

    group('normalize() with missing embeds field', () {
      test('defaults embeds to empty list when field is absent', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
          'content': 'no embeds',
          'guild_id': '987654321',
          'author': {'id': '444555666', 'bot': false},
          'timestamp': '2024-06-01T12:00:00.000Z',
          'edited_timestamp': null,
        };

        final result = await serializer.normalize(payload);

        expect(result['embeds'], isA<List>());
        expect(result['embeds'], isEmpty);
      });

      test('defaults embeds to empty list when field is null', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
          'content': 'null embeds',
          'embeds': null,
          'guild_id': '987654321',
          'author': {'id': '444555666', 'bot': false},
          'timestamp': '2024-06-01T12:00:00.000Z',
          'edited_timestamp': null,
        };

        final result = await serializer.normalize(payload);

        expect(result['embeds'], isA<List>());
        expect(result['embeds'], isEmpty);
      });
    });

    group('normalize() with minimal valid payload', () {
      test('does not crash with only id and channel_id', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
        };

        final result = await serializer.normalize(payload);

        expect(result['id'], equals('111222333'));
        expect(result['channel_id'], equals('444555666'));
        expect(result['author_id'], isNull);
        expect(result['author_is_bot'], isNull);
        expect(result['content'], isNull);
        expect(result['server_id'], isNull);
        expect(result['timestamp'], isNull);
        expect(result['edited_timestamp'], isNull);
      });

      test('defaults embeds to empty list in minimal payload', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
        };

        final result = await serializer.normalize(payload);

        expect(result['embeds'], isA<List>());
        expect(result['embeds'], isEmpty);
      });

      test('writes to cache with minimal payload', () async {
        final payload = {
          'id': '111222333',
          'channel_id': '444555666',
        };

        await serializer.normalize(payload);

        final expectedKey = CacheKey().message('444555666', '111222333');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });
    });
  });

  group('InviteSerializer edge cases', () {
    late InviteSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      final testIoc = createTestIoc();
      cache = _FakeCacheProvider();
      testIoc.container.bind<MarshallerContract>(
          () => _FakeMarshaller(logger: testIoc.logger, cache: cache));
      restoreIoc = testIoc.restore;
      serializer = InviteSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    group('normalize() with null inviter (vanity invites)', () {
      test(
          'crashes when inviter is null due to voiceState requiring non-nullable args',
          () async {
        // BUG: cacheKey.voiceState() expects (Object, Object) but receives
        // null for inviter?['id']. This causes a TypeError at runtime.
        // Vanity invites from the Discord API can have inviter: null.
        final payload = {
          'channel_id': '111222333',
          'code': 'vanity-url',
          'created_at': '2024-06-01T12:00:00.000Z',
          'expires_at': null,
          'guild_id': '987654321',
          'inviter': null,
          'max_age': 0,
          'max_uses': 0,
          'temporary': false,
          'type': 0,
        };

        expect(
          () => serializer.normalize(payload),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('normalize() with missing optional fields', () {
      test('crashes when inviter is absent due to voiceState null arg',
          () async {
        // BUG: Same root cause as the null inviter test above.
        // When inviter key is missing, inviter?['id'] is null,
        // which is passed to cacheKey.voiceState().
        final payload = {
          'code': 'abc123',
          'guild_id': '987654321',
          'type': 0,
        };

        expect(
          () => serializer.normalize(payload),
          throwsA(isA<TypeError>()),
        );
      });

      test('handles null expires_at gracefully', () async {
        final payload = {
          'channel_id': '111222333',
          'code': 'abc123',
          'created_at': '2024-06-01T12:00:00.000Z',
          'expires_at': null,
          'guild_id': '987654321',
          'inviter': {'id': '444555666'},
          'max_age': 0,
          'max_uses': 0,
          'temporary': false,
          'type': 0,
        };

        final result = await serializer.normalize(payload);

        expect(result['expiresAt'], isNull);
      });
    });
  });

  group('MessageReactionSerializer edge cases', () {
    late MessageReactionSerializer serializer;

    setUp(() {
      serializer = MessageReactionSerializer();
    });

    group('serialize() with null emoji field', () {
      test('handles null emoji gracefully with empty name fallback', () async {
        // The serializer handles null emoji by defaulting name to '' and
        // animated to false, so no TypeError is thrown.
        final payload = {
          'server_id': '987654321',
          'channel_id': '111222333',
          'author_id': '444555666',
          'message_id': '777888999',
          'emoji': null,
          'is_burst': false,
          'type': 0,
        };

        final reaction = await serializer.serialize(payload);

        expect(reaction.emoji.id, isNull);
        expect(reaction.emoji.name, equals(''));
        expect(reaction.emoji.animated, isFalse);
      });

      test('handles emoji with null id (unicode emoji)', () async {
        final payload = {
          'server_id': '987654321',
          'channel_id': '111222333',
          'author_id': '444555666',
          'message_id': '777888999',
          'emoji': {
            'id': null,
            'name': '\u{1F44D}',
            'animated': false,
          },
          'is_burst': false,
          'type': 0,
        };

        final reaction = await serializer.serialize(payload);

        expect(reaction.emoji.id, isNull);
        expect(reaction.emoji.name, equals('\u{1F44D}'));
        expect(reaction.emoji.animated, isFalse);
      });
    });

    group('normalize() with null emoji field', () {
      test('passes null emoji through without crashing', () async {
        final payload = {
          'guild_id': '987654321',
          'channel_id': '111222333',
          'user_id': '444555666',
          'message_id': '777888999',
          'emoji': null,
          'burst': false,
          'type': 0,
        };

        final result = await serializer.normalize(payload);

        expect(result['emoji'], isNull);
      });
    });
  });
}
