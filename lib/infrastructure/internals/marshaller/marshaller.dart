import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/cache/cache_provider_contract.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializer_bucket.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class MarshallerContract {
  DataStoreContract get dataStore;

  LoggerContract get logger;

  SerializerBucket get serializers;

  CacheProviderContract get cache;
}

final class Marshaller implements MarshallerContract {
  @override
  DataStoreContract get dataStore => ioc.resolve('datastore');

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
