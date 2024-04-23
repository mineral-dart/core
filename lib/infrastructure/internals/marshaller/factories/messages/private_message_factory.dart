import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
  @override
  Future<PrivateMessage> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final reactionSerializer = DataStore.singleton().marshaller.serializers.reactionEmoji;
    final reactions = <ReactionEmoji<PrivateChannel>>[];
    final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json, reactions);
    final user = await marshaller.serializers.user.serialize(json['author']);

    for (final reactionRaw in json['reactions'] ?? []) {
      reactionRaw['message'] = json;
      reactionRaw['channel_id'] = json['channel_id'];
      final reaction = await reactionSerializer.serialize(reactionRaw) as ReactionEmoji<PrivateChannel>;
      messageProperties.reactions.add(reaction);
    }

    return PrivateMessage(messageProperties, userId: json['author']['id'], user: user)
      ..channel = channel;
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, PrivateMessage message) async {
    return {
      'id': message.id,
      'content': message.content,
      'author': await marshaller.serializers.user.deserialize(message.user),
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel': message.channel.id,
      'timestamp': message.createdAt.toIso8601String(),
      'edited_timestamp': message.updatedAt?.toIso8601String(),
    };
  }
}
