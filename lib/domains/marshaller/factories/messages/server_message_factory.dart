import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/message_factory.dart';

final class ServerMessageFactory implements MessageFactory<ServerMessage> {
  @override
  Future<ServerMessage> serialize(
      MarshallerContract marshaller, Map<String, dynamic> json, bool cache) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final messageProperties = MessageProperties.fromJson(channel as ServerChannel, json);

    final member = await marshaller.dataStore.member
        .getMember(memberId: json['author']['id'], guildId: json['guild_id']);

    return ServerMessage(messageProperties, author: member);
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
