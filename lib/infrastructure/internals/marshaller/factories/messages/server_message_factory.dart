import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  @override
  Future<ServerMessage> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final reactionSerializer =Marshaller.singleton().serializers.reactionEmoji;
    final reactions = <ReactionEmoji<ServerChannel>>[];
    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json, reactions);
    final member = await marshaller.dataStore.member.getMemberOrNull(memberId: json['author']['id'], guildId: json['guild_id']);

    for (final reactionRaw in json['reactions'] ?? []) {
      reactionRaw['message'] = json;
      reactionRaw['channel_id'] = json['channel_id'];
      final reaction = await reactionSerializer.serialize(reactionRaw) as ReactionEmoji<ServerChannel>;
      messageProperties.reactions.add(reaction);
    }

    return ServerMessage(messageProperties, author: member)..channel = channel;
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerMessage message) async {
    return {
      'id': message.id,
      'content': message.content,
      'author': message.author != null ? await marshaller.serializers.member.deserialize(message.author!) : null,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel': message.channel.id,
      'guild_id': message.channel.guildId,
      'timestamp': message.createdAt.toIso8601String(),
      'edited_timestamp': message.updatedAt?.toIso8601String(),
    };
  }
}
