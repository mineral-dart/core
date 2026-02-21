import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/voice_state_serializer.dart';
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
  group('VoiceStateSerializer', () {
    late VoiceStateSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = VoiceStateSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> normalizedPayload() => {
          'server_id': '987654321',
          'channel_id': '111222333',
          'user_id': '444555666',
          'session_id': 'sess_abc123',
          'deaf': false,
          'mute': false,
          'self_deaf': true,
          'self_mute': true,
          'self_video': false,
          'suppress': false,
          'request_to_speak_timestamp': null,
          'discoverable': true,
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'guild_id': '987654321',
          'channel_id': '111222333',
          'user_id': '444555666',
          'session_id': 'sess_abc123',
          'deaf': false,
          'mute': false,
          'self_deaf': true,
          'self_mute': true,
          'self_video': false,
          'suppress': false,
          'request_to_speak_timestamp': null,
          'discoverable': true,
        };

    group('serialize()', () {
      test('maps all fields correctly', () async {
        final state = await serializer.serialize(normalizedPayload());

        expect(state, isA<VoiceState>());
        expect(state.serverId, equals(Snowflake('987654321')));
        expect(state.channelId, equals(Snowflake('111222333')));
        expect(state.userId, equals(Snowflake('444555666')));
        expect(state.sessionId, equals('sess_abc123'));
        expect(state.isDeaf, isFalse);
        expect(state.isMute, isFalse);
        expect(state.isSelfDeaf, isTrue);
        expect(state.isSelfMute, isTrue);
        expect(state.hasSelfVideo, isFalse);
        expect(state.isSuppress, isFalse);
        expect(state.requestToSpeakTimestamp, isNull);
        expect(state.isDiscoverable, isTrue);
      });

      test('handles nullable channelId', () async {
        final payload = normalizedPayload()..['channel_id'] = null;
        final state = await serializer.serialize(payload);

        expect(state.channelId, isNull);
      });

      test('parses requestToSpeakTimestamp when present', () async {
        final ts = '2024-01-15T10:30:00.000Z';
        final payload = normalizedPayload()
          ..['request_to_speak_timestamp'] = ts;
        final state = await serializer.serialize(payload);

        expect(state.requestToSpeakTimestamp, isA<DateTime>());
        expect(state.requestToSpeakTimestamp, equals(DateTime.parse(ts)));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () async {
        final state = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(state);

        expect(result['server_id'], equals(Snowflake('987654321').value));
        expect(result['channel_id'], equals(Snowflake('111222333').value));
        expect(result['user_id'], equals(Snowflake('444555666').value));
        expect(result['session_id'], equals('sess_abc123'));
        expect(result['deaf'], isFalse);
        expect(result['mute'], isFalse);
        expect(result['self_deaf'], isTrue);
        expect(result['self_mute'], isTrue);
        expect(result['suppress'], isFalse);
        expect(result['discoverable'], isTrue);
      });

      test('serializes nullable channelId as null', () async {
        final payload = normalizedPayload()..['channel_id'] = null;
        final state = await serializer.serialize(payload);
        final result = serializer.deserialize(state);

        expect(result['channel_id'], isNull);
      });

      // Anomaly: deserialize writes 'self_stream' but serialize reads 'self_video'
      test('writes self_stream key instead of self_video', () async {
        final state = await serializer.serialize(normalizedPayload());
        final result = serializer.deserialize(state);

        expect(result.containsKey('self_stream'), isTrue);
        expect(result.containsKey('self_video'), isFalse);
      });
    });

    group('normalize()', () {
      test('writes to cache with voiceState key', () async {
        await serializer.normalize(rawDiscordPayload());

        final expectedKey = CacheKey().voiceState('987654321', '444555666');
        expect(cache.store.containsKey(expectedKey), isTrue);
      });

      test('renames guild_id to server_id', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result, containsPair('server_id', '987654321'));
        expect(result.containsKey('guild_id'), isFalse);
      });
    });
  });
}
