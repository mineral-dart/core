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
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'content': json['content'],
      'embeds': json['embeds'],
      'channel_id': json['channel_id'],
      'created_at': json['created_at'],
      'updated_at': json['updated_at'],
    };

    final cacheKey = marshaller.cacheKey.message(Snowflake(json['channel_id']), json['id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final properties = MessageProperties<PrivateChannel>(
      id: Snowflake(json['id']),
      content: json['content'],
      embeds: json['embeds'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      channelId: Snowflake(json['channel_id']),
    );

    final user = await marshaller.serializers.user.serialize(json['user']);

    return PrivateMessage(properties, userId: user.id, author: user);
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
