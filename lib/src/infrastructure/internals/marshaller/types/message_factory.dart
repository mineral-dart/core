import 'package:mineral/src/api/common/message.dart';

abstract interface class MessageFactory<T extends BaseMessage> {
  Future<T> serialize(Map<String, dynamic> json);
  Map<String, dynamic> deserialize(T message);
}
