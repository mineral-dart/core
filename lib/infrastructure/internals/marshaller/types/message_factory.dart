import 'package:mineral/api/common/message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

abstract interface class MessageFactory<T extends Message> {
  Future<T> serialize(MarshallerContract marshaller, Map<String, dynamic> json);
  Map<String, dynamic> deserialize(MarshallerContract marshaller, T message);
}
