import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

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

    dispatch(event: MineralEvent.privateMessageReactionAdd, params: [message, reaction, message.channel, user]);
  }

  Future<void> sendServerReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id'], serverId: json['guild_id']) as ServerMessage;
    final reaction = await marshaller.serializers.reactionEmoji.serialize(json)
    ..message = message;
    final member = await marshaller.dataStore.member.getMember(guildId: json['guild_id'], memberId: json['user_id']);

    dispatch(event: MineralEvent.serverMessageReactionAdd, params: [message, reaction, member.server, member]);
  }
}
