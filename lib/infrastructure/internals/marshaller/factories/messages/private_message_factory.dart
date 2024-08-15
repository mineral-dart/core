import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
  @override
  Future<PrivateMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = json['channel'] as Channel;
    final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json);

    final user = await marshaller.serializers.user.serialize(json['author']);

    return PrivateMessage(messageProperties, userId: json['author']['id'], author: user);
  }

  @override
  Map<String, dynamic> deserialize(
      MarshallerContract marshaller, PrivateMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel_id': message.channel.id,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
