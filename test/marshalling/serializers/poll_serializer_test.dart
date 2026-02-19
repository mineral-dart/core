import 'dart:async';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/polls/poll_layout.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializers/poll_serializer.dart';
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
  group('PollSerializer', () {
    late PollSerializer serializer;
    late _FakeCacheProvider cache;
    late void Function() restoreIoc;

    setUp(() {
      cache = _FakeCacheProvider();
      final scope = IocContainer()
        ..bind<MarshallerContract>(() => _FakeMarshaller(cache: cache));
      restoreIoc = scopedIoc(scope);
      serializer = PollSerializer();
    });

    tearDown(() {
      restoreIoc();
    });

    Map<String, dynamic> serializePayload() => {
          'message_id': '777888999',
          'question_text': 'What is your favorite color?',
          'answers': [
            {'text': 'Red', 'emoji': null},
            {'text': 'Blue', 'emoji': null},
          ],
          'expiry': null,
          'allow_multiselect': false,
          'layout_type': 1,
        };

    Map<String, dynamic> rawDiscordPayload() => {
          'message_id': '777888999',
          'question': {'text': 'What is your favorite color?'},
          'answers': [
            {'text': 'Red'},
            {'text': 'Blue'},
          ],
          'expiry': null,
          'allow_multiselect': false,
          'layout_type': 1,
        };

    group('serialize()', () {
      test('maps question correctly', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll, isA<Poll>());
        expect(poll.question.content, equals('What is your favorite color?'));
      });

      test('maps answers list', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll.answers, hasLength(2));
        expect(poll.answers[0].content, equals('Red'));
        expect(poll.answers[1].content, equals('Blue'));
      });

      test('maps messageId', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll.messageId, equals(Snowflake('777888999')));
      });

      test('handles null expiry', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll.expireAt, isNull);
      });

      test('maps allow_multiselect', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll.isAllowMultiple, isFalse);
      });

      test('resolves PollLayout.initial for layout_type 1', () {
        final poll = serializer.serialize(serializePayload());

        expect(poll.layout, equals(PollLayout.initial));
      });
    });

    group('deserialize()', () {
      test('produces map with expected keys', () {
        final poll = serializer.serialize(serializePayload());
        final result = serializer.deserialize(poll);

        expect(result['question_text'], equals('What is your favorite color?'));
        expect(result['allow_multiselect'], isFalse);
        expect(result['layout_type'], equals(PollLayout.initial.value));
      });

      test('question is serialized via toJson', () {
        final poll = serializer.serialize(serializePayload());
        final result = serializer.deserialize(poll);

        expect(result['question'], isA<Map>());
        expect(
            result['question']['text'], equals('What is your favorite color?'));
      });

      test('answers are serialized as list', () {
        final poll = serializer.serialize(serializePayload());
        final result = serializer.deserialize(poll);

        expect(result['answers'], isA<List>());
        expect(result['answers'], hasLength(2));
      });
    });

    group('normalize()', () {
      test('writes to cache with poll key', () async {
        await serializer.normalize(rawDiscordPayload());

        expect(cache.store.isNotEmpty, isTrue);
      });

      test('extracts question text from nested object', () async {
        final result = await serializer.normalize(rawDiscordPayload());

        expect(result['question_text'], equals('What is your favorite color?'));
      });
    });

    group('round-trip', () {
      test('serialize then deserialize preserves key data', () {
        final json = serializePayload();
        final poll = serializer.serialize(json);
        final result = serializer.deserialize(poll);

        expect(result['allow_multiselect'], equals(json['allow_multiselect']));
        expect(result['layout_type'], equals(json['layout_type']));
        expect(result['question_text'], equals(json['question_text']));
      });
    });
  });
}
