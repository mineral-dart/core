import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class MessageSerializer<T extends Message> implements SerializerContract<T> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'author_id': json['author']['id'],
      'content': json['content'],
      'embeds': json['embeds'],
      'channel_id': json['channel_id'],
      'server_id': json['guild_id'],
      'author_is_bot': json['author']['bot'],
      'timestamp': json['timestamp'],
      'edited_timestamp': json['edited_timestamp'],
    };

    final cacheKey = _marshaller.cacheKey.message(json['channel_id'], json['id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<T> serialize(Map<String, dynamic> json) async {
    final messageProperties = MessageProperties.fromJson(json);
    return Message(messageProperties) as T;
  }

  @override
  Future<Map<String, dynamic>> deserialize(T object) async {
    final embeds = object.embeds.map((message) {
      return _marshaller.serializers.embed.deserialize(message);
    });

    return {
      'id': object.id,
      'content': object.content,
      'embeds': embeds.toList(),
      'author_id': object.authorId?.value,
      'channel_id': object.channelId.value,
      'server_id': object.serverId?.value,
      'author_is_bot': object.authorIsBot,
      'timestamp': object.createdAt.toIso8601String(),
      'edited_timestamp': object.updatedAt?.toIso8601String(),
    };
  }
}
