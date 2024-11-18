import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class PrivateMessageSerializer implements SerializerContract<PrivateMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

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

    final cacheKey = _marshaller.cacheKey.message(Snowflake(json['channel_id']), json['id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<PrivateMessage> serialize(Map<String, dynamic> json) async {
    final List<MessageEmbed> embeds =
        await Future.wait(List.from(json['embeds']).map((message) async {
      return _marshaller.serializers.embed.serialize(message);
    }));

    final properties = MessageProperties<PrivateChannel>(
      id: Snowflake(json['id']),
      content: json['content'],
      embeds: embeds,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      channelId: Snowflake(json['channel_id']),
    );

    final user = await _dataStore.user.getUser(json['user_id']);

    return PrivateMessage(properties, userId: user.id, author: user);
  }

  @override
  Future<Map<String, dynamic>> deserialize(PrivateMessage object) async {
    final embeds = await Future.wait(object.embeds.map((message) async {
      return _marshaller.serializers.embed.deserialize(message);
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
