import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';

abstract interface class MessageFactory<T extends Message> {
  Future<T> serialize(Map<String, dynamic> json);
  Map<String, dynamic> deserialize(T message);
}
