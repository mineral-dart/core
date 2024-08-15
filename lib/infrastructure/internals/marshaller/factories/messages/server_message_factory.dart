import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  @override
  Future<ServerMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final member = server.members.list[json['author']['id']];

    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json);

    return ServerMessage(messageProperties, author: member!);
  }

  @override
  Map<String, dynamic> deserialize(
      MarshallerContract marshaller, ServerMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel_id': message.channel.id,
      'guild_id': message.channel.serverId,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
