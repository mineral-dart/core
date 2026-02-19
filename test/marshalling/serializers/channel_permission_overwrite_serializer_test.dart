import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/permission.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/channel_permission_overwrite_serializer.dart';
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
  group('ChannelPermissionOverwriteSerializer', () {
    late ChannelPermissionOverwriteSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = ChannelPermissionOverwriteSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'id': '123456789',
          'type': 0,
          'allow': '8',
          'deny': '0',
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'id': '123456789',
          'type': 0,
          'allow': '8',
          'deny': '0',
          'server_id': '987654321',
        };

    group('serialize()', () {
      test('maps fields correctly', () {
        final overwrite = serializer.serialize(normalizedPayload());

        expect(overwrite, isA<ChannelPermissionOverwrite>());
        expect(overwrite.id, equals('123456789'));
        expect(overwrite.type, equals(ChannelPermissionOverwriteType.role));
      });

      test('resolves member type for type 1', () {
        final payload = normalizedPayload()..['type'] = 1;
        final overwrite = serializer.serialize(payload);

        expect(overwrite.type, equals(ChannelPermissionOverwriteType.member));
      });

      test('parses allow bitfield from string', () {
        final payload = normalizedPayload()..['allow'] = '8';
        final overwrite = serializer.serialize(payload);

        expect(overwrite.allow, contains(Permission.administrator));
      });

      test('parses deny bitfield from string', () {
        final payload = normalizedPayload()..['deny'] = '2048';
        final overwrite = serializer.serialize(payload);

        expect(overwrite.deny, contains(Permission.sendMessages));
      });

      test('returns empty list for zero bitfield', () {
        final payload = normalizedPayload()..['allow'] = '0';
        final overwrite = serializer.serialize(payload);

        expect(overwrite.allow, isEmpty);
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () {
        final overwrite = serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(overwrite);

        expect(result, containsPair('id', '123456789'));
        expect(result,
            containsPair('type', ChannelPermissionOverwriteType.role.value));
      });
    });

    group('normalize()', () {
      test('writes to cache with channelPermission key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey =
            CacheKey().channelPermission('123456789', serverId: '987654321');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('preserves all fields', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['id'], equals('123456789'));
        expect(result['type'], equals(0));
        expect(result['allow'], equals('8'));
        expect(result['deny'], equals('0'));
      });
    });
  });
}
