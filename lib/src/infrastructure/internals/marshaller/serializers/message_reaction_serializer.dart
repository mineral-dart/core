import 'package:mineral/api.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class MessageReactionSerializer<T extends Message>
    implements SerializerContract<MessageReaction> {

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    return {
      'id': json['id'],
      'author_id': json['user_id'],
      'content': json['content'],
      'embeds': json['embeds'],
      'channel_id': json['channel_id'],
      'server_id': json['guild_id'],
      'emoji': json['emoji'],
      'message_id': json['message_id'],
      'timestamp': json['timestamp'],
      'edited_timestamp': json['edited_timestamp'],
      'is_burst': json['burst'],
      'type': json['type'],
    };
  }

  @override
  Future<MessageReaction> serialize(Map<String, dynamic> json) async {
    return MessageReaction(
        serverId: Snowflake.parse(json['server_id']),
        channelId: Snowflake.parse(json['channel_id']),
        userId: Snowflake.parse(json['author_id']),
        messageId: Snowflake.parse(json['message_id']),
        emoji: PartialEmoji(json['emoji']['id'], json['emoji']['name'],
            json['emoji']['animated'] ?? false),
        isBurst: json['is_burst'] ?? false,
        type: MessageReactionType.values[json['type']]);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MessageReaction object) async {
    return {
      'id': object.serverId.value,
      'author_id': object.channelId.value,
      'content': object.userId.value,
      'embeds': object.messageId.value,
      'channel_id': object.channelId?.value,
      'server_id': object.emoji.id,
      'emoji': {
        'id': object.emoji.id,
        'name': object.emoji.name,
        'animated': object.emoji.animated,
      },
      'message_id': object.messageId.value,
      'timestamp': object.isBurst,
      'edited_timestamp': object.type.value,
    };
  }
}
