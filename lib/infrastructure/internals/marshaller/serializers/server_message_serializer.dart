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
  Future<ServerMessage> serializeRemote(Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel<ServerChannel>(Snowflake(json['channel_id']));

    if (channel == null) {
      throw Exception('Channel not found');
    }

    final server = await marshaller.dataStore.server.getServer(channel.guildId);
    final member = server.members.list[json['author']['id']];

    final messageProperties = MessageProperties.fromJson(channel, json);

    return ServerMessage(messageProperties, author: member!);
  }

  @override
  Future<ServerMessage> serializeCache(Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel
        .getChannel(Snowflake(json['channel_id']));

    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
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
      'guild_id': object.channel.guildId.value,
      'timestamp': object.createdAt.toIso8601String(),
      'edited_timestamp': object.updatedAt?.toIso8601String(),
    };
  }
}
