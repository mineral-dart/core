import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/private_reaction.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/message_factory.dart';

final class PrivateMessageFactory implements MessageFactory<PrivateMessage> {
@override
  Future<PrivateMessage> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
  final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
  final messageProperties = MessageProperties.fromJson(channel as PrivateChannel, json);
  final user = await marshaller.serializers.user.serialize(json['author']);
  final reactionsProperties = List.from(json['reactions']).map((e) => ReactionProperties.fromJson(e, null)).toList();
  final reactions = reactionsProperties.map(PrivateReaction.new).toList();
  final message = PrivateMessage(messageProperties, userId: json['author']['id'], user: user, reactions: reactions)
    ..channel = channel;

  reactions.forEach((reaction) {
    reaction..channel = channel
    ..message = message;
  });

  return message;
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, PrivateMessage message) async {
    return {
      'id': message.id,
      'content': message.content,
      'embeds': message.embeds.map(marshaller.serializers.embed.deserialize).toList(),
      'channel': message.channel.id,
      'created_at': message.createdAt.toIso8601String(),
      'updated_at': message.updatedAt?.toIso8601String(),
    };
  }
}
