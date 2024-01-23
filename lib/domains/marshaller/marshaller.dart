import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/marshaller/serializer_bucket.dart';

abstract interface class MarshallerContract {
  SerializerBucket get serializers;
  MemoryStorageContract get storage;
}

final class Marshaller implements MarshallerContract {
  @override
  late final SerializerBucket serializers;

  @override
  final MemoryStorageContract storage;

  Marshaller(this.storage) {
    serializers = SerializerBucketImpl(this);
  }
}
