import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/datastore/datastore.dart';
import 'package:mineral/src/infrastructure/internals/datastore/request_bucket.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/src/infrastructure/services/http/http_client.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_config.dart';
import 'package:test/test.dart';

// ── Fakes ─────────────────────────────────────────────────────────────────────

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

final class _FakeMarshaller implements MarshallerContract {
  final _FakeLogger _logger = _FakeLogger();

  @override
  LoggerContract get logger => _logger;

  @override
  late final SerializerBucket serializers = SerializerBucket(this);

  @override
  CacheProviderContract? get cache => null;

  @override
  CacheKey get cacheKey => CacheKey();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('DataStore', () {
    late DataStore dataStore;

    setUp(() {
      final config =
          HttpClientConfigImpl(uri: Uri.parse('https://discord.com/api/v10'));
      final client = HttpClient(config: config);
      dataStore = DataStore(client: client, marshaller: _FakeMarshaller());
    });

    test('stores the HttpClient', () {
      expect(dataStore.client, isA<HttpClient>());
    });

    test('requestBucket is initialized', () {
      expect(dataStore.requestBucket, isA<RequestBucket>());
    });

    test('requestBucket queue is empty', () {
      expect(dataStore.requestBucket.queue, isEmpty);
    });

    test('requestBucket hasGlobalLocked is false', () {
      expect(dataStore.requestBucket.hasGlobalLocked, isFalse);
    });

    test('all parts are initialized', () {
      expect(dataStore.channel, isNotNull);
      expect(dataStore.server, isNotNull);
      expect(dataStore.member, isNotNull);
      expect(dataStore.user, isNotNull);
      expect(dataStore.role, isNotNull);
      expect(dataStore.message, isNotNull);
      expect(dataStore.interaction, isNotNull);
      expect(dataStore.sticker, isNotNull);
      expect(dataStore.emoji, isNotNull);
      expect(dataStore.reaction, isNotNull);
      expect(dataStore.thread, isNotNull);
      expect(dataStore.rules, isNotNull);
      expect(dataStore.invite, isNotNull);
    });
  });
}
