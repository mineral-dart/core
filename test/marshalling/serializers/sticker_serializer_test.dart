import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/api/common/types/format_type.dart';
import 'package:mineral/src/api/common/types/sticker_type.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/sticker_serializer.dart';
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
  group('StickerSerializer', () {
    late StickerSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = StickerSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'id': '111222333',
          'name': 'cool_sticker',
          'type': 2,
          'available': true,
          'pack_id': 'pack_001',
          'description': 'A cool sticker',
          'tags': 'cool,fun',
          'asset': null,
          'format_type': 1,
          'sort_value': 5,
          'server_id': '987654321',
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'id': '111222333',
          'name': 'cool_sticker',
          'type': 2,
          'available': true,
          'pack_id': 'pack_001',
          'description': 'A cool sticker',
          'tags': 'cool,fun',
          'asset': null,
          'format_type': 1,
          'sort_value': 5,
          'guild_id': '987654321',
        };

    group('serialize()', () {
      test('maps all fields correctly', () {
        final sticker = serializer.serialize(normalizedPayload());

        expect(sticker, isA<Sticker>());
        expect(sticker.id, equals(Snowflake('111222333')));
        expect(sticker.name, equals('cool_sticker'));
        expect(sticker.type, equals(StickerType.guild));
        expect(sticker.isAvailable, isTrue);
        expect(sticker.packId, equals('pack_001'));
        expect(sticker.description, equals('A cool sticker'));
        expect(sticker.tags, equals('cool,fun'));
        expect(sticker.formatType, equals(FormatType.standard));
        expect(sticker.sortValue, equals(5));
        expect(sticker.serverId, equals(Snowflake('987654321')));
      });

      test('resolves StickerType.standard for type 1', () {
        final payload = normalizedPayload()..['type'] = 1;
        final sticker = serializer.serialize(payload);

        expect(sticker.type, equals(StickerType.standard));
      });

      test('resolves FormatType.guild for format_type 2', () {
        final payload = normalizedPayload()..['format_type'] = 2;
        final sticker = serializer.serialize(payload);

        expect(sticker.formatType, equals(FormatType.guild));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys and values', () {
        final sticker = serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(sticker);

        expect(result['id'], equals(Snowflake('111222333')));
        expect(result['name'], equals('cool_sticker'));
        expect(result['type'], equals(StickerType.guild.value));
        expect(result['available'], isTrue);
        expect(result['pack_id'], equals('pack_001'));
        expect(result['description'], equals('A cool sticker'));
        expect(result['tags'], equals('cool,fun'));
        expect(result['format_type'], equals(FormatType.standard.value));
        expect(result['sort_value'], equals(5));
        expect(result['server_id'], equals(Snowflake('987654321')));
      });
    });

    group('normalize()', () {
      test('writes to cache with sticker key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().sticker('987654321', '111222333');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('renames guild_id to server_id', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('server_id', '987654321'));
        expect(result.containsKey('guild_id'), isFalse);
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () {
        final json = normalizedPayload();
        final sticker = serializer.serialize(json);
        final result = serializer.deserialize(sticker);

        expect(result['name'], equals(json['name']));
        expect(result['type'], equals(json['type']));
        expect(result['available'], equals(json['available']));
        expect(result['format_type'], equals(json['format_type']));
      });
    });
  });
}
