import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
@override
  Future<PrivateMessage> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
  final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
  final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json);

  final user = await marshaller.serializers.user.serialize(json['author']);

  return PrivateMessage(messageProperties, userId: json['author']['id'], user: user);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, PrivateMessage message) async {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel': message.channel.id,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
