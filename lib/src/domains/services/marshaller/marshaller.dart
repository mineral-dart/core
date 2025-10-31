import 'package:mineral/src/domains/services/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

abstract interface class MarshallerContract {
  LoggerContract get logger;
  SerializerBucket get serializers;
  CacheProviderContract? get cache;
  CacheKey get cacheKey;
}
