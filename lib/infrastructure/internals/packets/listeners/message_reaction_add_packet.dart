import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
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
    final guildId = message.payload['guild_id'];

    if (guildId == null) {
      return listenPrivate(message.payload, dispatch);
    }

    return listenServer(message.payload, dispatch);
  }

  Future<void> listenPrivate(Map payload, DispatchEvent dispatch) async {
    final user = await marshaller.dataStore.user.getUser(payload['user_id']);
    final channel = await marshaller.dataStore.channel.getChannel<PrivateChannel>(payload['channel_id']);
    final message = await marshaller.dataStore.channel.getMessage<PrivateMessage>(payload['channel_id'], payload['message_id']) as PrivateMessage;

    print('User ${user.username} reacted to a message in channel ${channel.name}, message: ${message.content}');
    print('Reaction: ${message.reactions.first.emoji}');
  }

  Future<void> listenServer(Map payload, DispatchEvent dispatch) async {
      final member = await marshaller.dataStore.member.getMember(guildId: payload['guild_id'], memberId: payload['user_id']);
      final channel = await marshaller.dataStore.channel.getChannel<ServerChannel>(payload['channel_id']);
      final message = await marshaller.dataStore.channel.getMessage<ServerMessage>(payload['channel_id'], payload['message_id'], guildId: payload['guild_id']);

      print('Member ${member.username} reacted to a message in channel ${channel.name}, message: ${message.content}, reaction: ${payload['emoji']}');
  }
}
