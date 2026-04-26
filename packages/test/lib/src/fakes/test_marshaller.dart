import 'package:mineral/contracts.dart';
import 'package:mineral/mineral_testing.dart';
// ignore: implementation_imports
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
// ignore: implementation_imports
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

/// Minimal [MarshallerContract] used by [TestKernel].
///
/// No cache by default. Pass an injected [logger] to share it with the test
/// (e.g. when the test needs to assert on log output).
final class TestMarshaller implements MarshallerContract {
  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers = SerializerBucket(this);

  @override
  final CacheProviderContract? cache;

  @override
  final CacheKey cacheKey = CacheKey();

  TestMarshaller({LoggerContract? logger, this.cache})
      : logger = logger ?? FakeLogger();
}
