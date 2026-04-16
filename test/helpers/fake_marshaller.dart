import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

import 'fake_logger.dart';

/// A minimal [MarshallerContract] for use in tests.
/// Has no cache by default; pass a [CacheProviderContract] to enable caching.
final class FakeMarshaller implements MarshallerContract {
  @override
  final LoggerContract logger = FakeLogger();

  @override
  late final SerializerBucket serializers = SerializerBucket(this);

  @override
  final CacheProviderContract? cache;

  @override
  final CacheKey cacheKey = CacheKey();

  FakeMarshaller({this.cache});
}
