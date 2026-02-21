import 'package:mineral/src/infrastructure/internals/datastore/request_bucket.dart';
import 'package:mineral/src/infrastructure/services/http/request.dart';
import 'package:test/test.dart';

void main() {
  group('RequestBucket', () {
    test('hasGlobalLocked defaults to false', () {
      final bucket = RequestBucket();
      expect(bucket.hasGlobalLocked, isFalse);
    });

    test('queue defaults to empty list', () {
      final bucket = RequestBucket();
      expect(bucket.queue, isEmpty);
    });

    test('query returns a RequestHandler', () {
      final bucket = RequestBucket();
      final request = Request.json(endpoint: '/test');
      final handler = bucket.query(request);
      expect(handler, isA<RequestHandler>());
    });

    test('hasGlobalLocked can be set to true', () {
      final bucket = RequestBucket()..hasGlobalLocked = true;
      expect(bucket.hasGlobalLocked, isTrue);
    });
  });
}
