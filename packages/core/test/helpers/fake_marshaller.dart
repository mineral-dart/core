import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

import 'fake_logger.dart';

/// A minimal [MarshallerContract] for use in tests.
///
/// Has no cache by default; pass a [CacheProviderContract] to enable caching.
/// Pass a [logger] to share the same [FakeLogger] instance with the test so
/// that log assertions work correctly.
final class FakeMarshaller implements MarshallerContract {
  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers = SerializerBucket(this);

  @override
  final CacheProviderContract? cache;

  @override
  final CacheKey cacheKey = CacheKey();

  FakeMarshaller({LoggerContract? logger, this.cache})
      : logger = logger ?? FakeLogger();
}
