import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/marshaller/memory_storage.dart';
import 'package:mineral/domains/marshaller/serializer_bucket.dart';

abstract interface class MarshallerContract {
  LoggerContract get logger;

  SerializerBucket get serializers;

  MemoryStorageContract get storage;
}

final class Marshaller implements MarshallerContract {
  @override
  final LoggerContract logger;

  @override
  late final SerializerBucket serializers;

  @override
  final MemoryStorageContract storage;

  Marshaller(this.logger, this.storage) {
    serializers = SerializerBucketImpl(this);
  }
}
