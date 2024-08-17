import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerMessageSerializer implements SerializerContract<ServerMessage> {
  final MarshallerContract marshaller;

  ServerMessageSerializer(this.marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'content': json['content'],
      'embeds': json['embeds'],
     // 'components': json['components'],
      'channel_id': json['channel_id'],
      'server_id': json['guild_id'],
      'timestamp': json['timestamp'],
      'edited_timestamp': json['edited_timestamp'],
    };

    final cacheKey = marshaller.cacheKey.serverMessage(messageId: json['id'], channelId: Snowflake(json['channel_id']));
    await marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerMessage> serialize(Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel
        .getChannel(Snowflake(json['channel_id']));

    final server = await marshaller.dataStore.server.getServer(json['server_id']);
    final member = server.members.list[json['author_id']];

    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json);

    return ServerMessage(messageProperties, author: member!);
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerMessage object) async {
    final embeds = await Future.wait(object.embeds.map((message) async {
      return marshaller.serializers.embed.deserialize(message);
    }));

    return {
      'id': object.id,
      'content': object.content,
      'embeds': embeds,
      'author_id': object.author.id.value,
      'channel_id': object.channel.id.value,
      'server_id': object.channel.guildId.value,
      'timestamp': object.createdAt.toIso8601String(),
      'edited_timestamp': object.updatedAt?.toIso8601String(),
    };
  }
}
