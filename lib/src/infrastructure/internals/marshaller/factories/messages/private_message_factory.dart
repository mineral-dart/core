import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
  @override
  Future<PrivateMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = json['channel'] as Channel;
    final messageProperties =
        MessageProperties.fromJson(channel as PrivateChannel, json);

    final user = await marshaller.serializers.user.serialize(json['author']);
    final poll = json['poll'] != null
        ? await marshaller.serializers.poll.serialize(json['poll'])
        : null;

    return PrivateMessage(messageProperties,
        userId: json['author']['id'], author: user, poll: poll);
  }

  @override
  Map<String, dynamic> deserialize(
      MarshallerContract marshaller, PrivateMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds':
          message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel_id': message.channel.id,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
