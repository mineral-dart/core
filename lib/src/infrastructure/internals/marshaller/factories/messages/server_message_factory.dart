import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  @override
  Future<ServerMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = json['channel'] as Channel;
    final server =
        await marshaller.dataStore.server.getServer(json['guild_id']);
    final member = server.members.list[json['author']['id']];

    final messageProperties =
        MessageProperties.fromJson(channel as ServerChannel, json);

    final poll = json['poll'] != null
        ? await marshaller.serializers.poll.serialize(json['poll'])
        : null;

    return ServerMessage(messageProperties, author: member!, poll: poll);
  }

  @override
  Map<String, dynamic> deserialize(
      MarshallerContract marshaller, ServerMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'embeds':
          message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel_id': message.channel.id,
      'guild_id': message.channel.serverId,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
