import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class PrivateMessageSerializer
    implements SerializerContract<PrivateMessage> {
  final MarshallerContract marshaller;

  PrivateMessageSerializer(this.marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'content': json['content'],
      'embeds': json['embeds'],
      'channel_id': json['channel_id'],
      'created_at': json['timestamp'],
      'updated_at': json['edited_timestamp'],
      'user_id': json['author']['id'],
    };

    final cacheKey =
        marshaller.cacheKey.message(Snowflake(json['channel_id']), json['id']);
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final List<MessageEmbed> embeds =
        await Future.wait(List.from(json['embeds']).map((message) async {
      return marshaller.serializers.embed.serialize(message);
    }));

    final properties = MessageProperties<PrivateChannel>(
      id: Snowflake(json['id']),
      content: json['content'],
      embeds: embeds,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      channelId: Snowflake(json['channel_id']),
    );

    final user = await marshaller.dataStore.user.getUser(json['user_id']);

    final poll = json['poll'] != null
        ? await marshaller.serializers.poll.serialize(json['poll'])
        : null;

    return PrivateMessage(properties,
        userId: user.id, author: user, poll: poll);
  }

  @override
  Future<Map<String, dynamic>> deserialize(PrivateMessage object) async {
    final embeds = await Future.wait(object.embeds.map((message) async {
      return marshaller.serializers.embed.deserialize(message);
    }));

    return {
      'id': object.id,
      'content': object.content,
      'embeds': embeds.toList(),
      'channel_id': object.channel.id,
      'created_at': object.createdAt.toIso8601String(),
      'updated_at': object.updatedAt?.toIso8601String(),
      'user_id': object.author.id,
    };
  }
}
