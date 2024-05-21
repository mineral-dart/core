import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessageReactionRemoveEmojiPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageReactionRemoveEmoji;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageReactionRemoveEmojiPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    return switch (message.payload['guild_id']) {
      String() => sendServerReactionMessage(dispatch, message.payload),
      _ => sendPrivateReactionMessage(dispatch, message.payload),
    };
  }

  Future<void> sendPrivateReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id']) as PrivateMessage;
    final emoji = await marshaller.serializers.emojis.serialize(json['emoji']);

    message.reactions.removeWhere((element) => element.emoji == emoji);

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.cache.put(message.id, messageRaw);

    dispatch(event: Event.privateMessageReactionRemoveEmoji, params: [message, emoji, message.channel]);
  }

  Future<void> sendServerReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id'], serverId: json['guild_id']) as ServerMessage;
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final emoji = await marshaller.serializers.emojis.serialize({
      ...json['emoji'],
      'guildRoles': server.roles.list.values.toList(),
      'roles': server.roles.list.keys.toList(),
    });

    message.reactions.removeWhere((element) => element.emoji == emoji);

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.cache.put(message.id, messageRaw);

    dispatch(event: Event.serverMessageReactionRemoveEmoji, params: [message, emoji, server]);
  }
}
