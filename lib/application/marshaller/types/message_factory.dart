import 'package:mineral/api/common/message.dart';
import 'package:mineral/application/marshaller/marshaller.dart';

abstract interface class MessageFactory<T extends Message> {
  Future<T> serialize(MarshallerContract marshaller, Map<String, dynamic> json);
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, T message);
}
