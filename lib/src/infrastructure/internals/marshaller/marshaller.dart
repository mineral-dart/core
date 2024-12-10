import 'package:mineral/src/domains/contracts/cache/cache_provider_contract.dart';
import 'package:mineral/src/domains/contracts/logger/logger_contract.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/cache_key.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/serializer_bucket.dart';

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
