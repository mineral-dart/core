import 'package:mineral/application/container/ioc_container.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/cache/contracts/cache_provider_contract.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/marshaller/serializer_bucket.dart';

abstract interface class MarshallerContract {
  DataStoreContract get dataStore;

  LoggerContract get logger;

  SerializerBucket get serializers;

  CacheProviderContract get cache;
}

final class Marshaller implements MarshallerContract {
  @override
  DataStoreContract get dataStore => ioc.resolve('data_store');

  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers;

  @override
  final CacheProviderContract cache;

  Marshaller(this.logger, this.cache) {
    serializers = SerializerBucketImpl(this);
  }
}
