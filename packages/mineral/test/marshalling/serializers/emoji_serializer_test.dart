import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/emoji.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/emoji_serializer.dart';
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
  group('EmojiSerializer', () {
    late EmojiSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = EmojiSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayloadWithoutRoles() => {
          'id': '100200300',
          'name': 'thumbsup',
          'managed': false,
          'available': true,
          'animated': false,
          'roles': <String>[],
          'server_id': '987654321',
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'id': '100200300',
          'name': 'thumbsup',
          'managed': false,
          'available': true,
          'animated': false,
          'roles': null,
          'guild_id': '987654321',
        };

    group('serialize()', () {
      test('creates Emoji without roles when roles is empty', () async {
        final emoji =
            await serializer.serialize(normalizedPayloadWithoutRoles());

        expect(emoji, isA<Emoji>());
        expect(emoji.id, equals(Snowflake('100200300')));
        expect(emoji.name, equals('thumbsup'));
        expect(emoji.managed, isFalse);
        expect(emoji.available, isTrue);
        expect(emoji.animated, isFalse);
        expect(emoji.roles, isEmpty);
        expect(emoji.serverId, equals(Snowflake('987654321')));
      });

      test('resolves roles from cache', () async {
        final roleKey = CacheKey().serverRole('987654321', '111111111');
        cache.store[roleKey] = {
          'id': '111111111',
          'name': 'Moderator',
          'color': 0,
          'hoist': false,
          'position': 1,
          'permissions': '0',
          'managed': false,
          'mentionable': false,
          'flags': 0,
          'server_id': '987654321',
        };

        final payload = normalizedPayloadWithoutRoles()..['roles'] = [roleKey];
        final emoji = await serializer.serialize(payload);

        expect(emoji.roles, hasLength(1));
        expect(emoji.roles.values.first.name, equals('Moderator'));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () async {
        final emoji =
            await serializer.serialize(normalizedPayloadWithoutRoles());
        final result = serializer.deserialize(emoji);

        expect(result['id'], equals(Snowflake('100200300').value));
        expect(result['name'], equals('thumbsup'));
        expect(result['managed'], isFalse);
        expect(result['available'], isTrue);
        expect(result['animated'], isFalse);
        expect(result['roles'], isEmpty);
        expect(result['server_id'], equals(Snowflake('987654321').value));
      });
    });

    group('normalize()', () {
      test('writes to cache with serverEmoji key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().serverEmoji('987654321', '100200300');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('transforms null roles into empty list', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['roles'], isA<List>());
        expect(result['roles'], isEmpty);
      });

      test('renames guild_id to server_id', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('server_id', '987654321'));
        expect(result.containsKey('guild_id'), isFalse);
      });
    });
  });
}
