import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerMessageSerializer
    implements SerializerContract<ServerMessage> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'author_id': json['author']['id'],
      'content': json['content'],
      'embeds': json['embeds'],
      // 'components': json['components'],
      'channel_id': json['channel_id'],
      'server_id': json['server_id'],
      'timestamp': json['timestamp'],
      'edited_timestamp': json['edited_timestamp'],
    };

    final cacheKey = _marshaller.cacheKey
        .message(Snowflake(json['channel_id']), Snowflake(json['id']));
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final channel =
        await _dataStore.channel.getChannel(Snowflake(json['channel_id']));

    final server = await _dataStore.server.getServer(json['server_id']);
    final member = await _dataStore.member
        .getMember(serverId: server.id, memberId: json['author_id']);

    final messageProperties =
        MessageProperties.fromJson(channel as ServerChannel, json);

    return ServerMessage(messageProperties, author: member);
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerMessage object) async {
    final embeds = object.embeds.map((message) {
      return _marshaller.serializers.embed.deserialize(message);
    });

    return {
      'id': object.id,
      'content': object.content,
      'embeds': embeds.toList(),
      'author_id': object.author.id.value,
      'channel_id': object.channel.id.value,
      'server_id': object.channel.serverId.value,
      'timestamp': object.createdAt.toIso8601String(),
      'edited_timestamp': object.updatedAt?.toIso8601String(),
    };
  }
}
