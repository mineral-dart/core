import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/api/server/server_reaction.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  @override
  Future<ServerMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json) async {
    print(json);
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final author = server.members.list[json['author']['id']];
    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json);

    final List<ServerReaction> reactions = [];

    for (final reaction in json['reactions']) {
      final member = reaction['member'] != null ? await marshaller.serializers.member.serialize(reaction['member']) : null;
      final reactionPropertie = ReactionProperties.fromJson(reaction, member);
      final serverReaction = ServerReaction(reactionPropertie)
        ..channel = channel;
      reactions.add(serverReaction);
    }

    final message = ServerMessage(messageProperties, author: author!, reactions: reactions)
      ..channel = channel;

    reactions.forEach((reaction) {
      reaction.message = message;
    });

    return message;
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerMessage message) async {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel': message.channel.id,
      'guild_id': message.channel.guildId,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
