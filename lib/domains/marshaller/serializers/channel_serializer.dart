import 'package:mineral/api/common/channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ChannelSerializer<T extends Channel> implements SerializerContract<T> {
  final MarshallerContract _marshaller;

  ChannelSerializer(this._marshaller);

  @override
  T serialize(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> deserialize(T object) {
    throw UnimplementedError();
  }
}
