import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final messageProperties = MessageProperties<ServerChannel>.fromJson(json);
    return Message(messageProperties);
  }

  @override
  Map<String, dynamic> deserialize(ServerMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds
          .map(_marshaller.serializers.embed.deserialize)
          .toList(),
      'channel_id': message.channelId.value,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
