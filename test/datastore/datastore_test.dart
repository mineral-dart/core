import 'package:mineral/src/infrastructure/internals/datastore/datastore.dart';
import 'package:mineral/src/infrastructure/internals/datastore/request_bucket.dart';
import 'package:mineral/src/infrastructure/services/http/http_client.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_config.dart';
import 'package:test/test.dart';

void main() {
  group('DataStore', () {
    late DataStore dataStore;

    setUp(() {
      final config =
          HttpClientConfigImpl(uri: Uri.parse('https://discord.com/api/v10'));
      final client = HttpClient(config: config);
      dataStore = DataStore(client);
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
  });
}
