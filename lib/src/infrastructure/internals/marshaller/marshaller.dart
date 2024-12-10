import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/infrastructure/internals/cache/cache_provider_contract.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

abstract interface class MarshallerContract {
  LoggerContract get logger;

  SerializerBucket get serializers;

  CacheProviderContract get cache;

  CacheKey get cacheKey;
}

final class Marshaller implements MarshallerContract {
  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers;

  @override
  final CacheProviderContract cache;

  @override
  final CacheKey cacheKey = CacheKey();

  Marshaller(this.logger, this.cache) {
    serializers = SerializerBucket(this);
  }
}
