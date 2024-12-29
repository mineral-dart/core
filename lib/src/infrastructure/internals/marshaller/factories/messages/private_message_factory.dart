import 'package:mineral/api.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final messageProperties = MessageProperties<PrivateChannel>.fromJson(json);
    return Message(messageProperties);
  }

  @override
  Map<String, dynamic> deserialize(PrivateMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(_marshaller.serializers.embed.deserialize).toList(),
      'channel_id': message.channelId,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
