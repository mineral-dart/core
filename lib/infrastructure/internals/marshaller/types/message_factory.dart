import 'package:mineral/api/common/message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

abstract interface class MessageFactory<T extends Message> {
  Future<T> serializeRemote(MarshallerContract marshaller, Map<String, dynamic> json);
  Future<T> serializeCache(MarshallerContract marshaller, Map<String, dynamic> json);
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, T message);
}
