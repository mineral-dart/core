import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class PrivateMessageSerializer implements SerializerContract<PrivateMessage> {
  final MarshallerContract marshaller;

  PrivateMessageSerializer(this.marshaller);

  @override
  Future<PrivateMessage> serializeRemote(Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(Snowflake(json['channel_id']));

    final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json);
    final user = await marshaller.serializers.user.serializeRemote(json['author']);

    return PrivateMessage(messageProperties, userId: json['author']['id'], author: user);
  }

  @override
  Future<PrivateMessage> serializeCache(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deserialize(PrivateMessage object) async {
    final embeds = await Future.wait(object.embeds.map((message) async {
      return marshaller.serializers.embed.deserialize(message);
    }));

    return {
      'id': object.id,
      'content': object.content,
      'embeds': embeds,
      'channel_id': object.channel.id,
      'created_at': object.createdAt.toIso8601String(),
      'updated_at': object.updatedAt?.toIso8601String(),
    };
  }
}
