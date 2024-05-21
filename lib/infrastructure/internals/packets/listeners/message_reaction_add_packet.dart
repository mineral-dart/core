import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessageReactionAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageReactionAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageReactionAddPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    return switch (message.payload['guild_id']) {
      String() => sendServerReactionMessage(dispatch, message.payload),
      _ => sendPrivateReactionMessage(dispatch, message.payload),
    };
  }

  Future<void> sendPrivateReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id']) as PrivateMessage;
    final reaction = await marshaller.serializers.reactionEmoji.serialize(json)
      ..message = message;
    final user = await marshaller.dataStore.user.getUser(json['user_id']);

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.cache.put(message.id, messageRaw);

    dispatch(event: Event.privateMessageReactionAdd, params: [message, reaction, message.channel, user]);
  }

  Future<void> sendServerReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id'], serverId: json['guild_id']) as ServerMessage;
    final reaction = await marshaller.serializers.reactionEmoji.serialize(json)
    ..message = message;
    final member = await marshaller.dataStore.member.getMemberOrNull(guildId: json['guild_id'], memberId: json['user_id']);
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.cache.put(message.id, messageRaw);

    dispatch(event: Event.serverMessageReactionAdd, params: [message, reaction, server, member]);
  }
}
