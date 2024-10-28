import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class MessagePollVoteRemove implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messagePollVoteAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessagePollVoteRemove(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    return switch (message.payload['guild_id']) {
      String() => _sendServerPoll(dispatch, message.payload),
      _ => _sendPrivatePoll(dispatch, message.payload),
    };
  }

  Future<void> _sendServerPoll(
      DispatchEvent dispatch, Map<String, dynamic> payload) async {
    final message = await marshaller.dataStore.message.getServerMessage(
      channelId: payload['channel_id'],
      messageId: payload['user_id'],
    );

    final user = marshaller.dataStore.user.getUser(payload['user_id']);

    dispatch(
        event: Event.serverPollVoteRemove, params: [message, user, String]);
  }

  Future<void> _sendPrivatePoll(
      DispatchEvent dispatch, Map<String, dynamic> payload) async {
    final message = await marshaller.dataStore.message.getPrivateMessage(
      channelId: payload['channel_id'],
      messageId: payload['user_id'],
    );

    final user = marshaller.dataStore.user.getUser(payload['user_id']);

    dispatch(
        event: Event.privatePollVoteRemove, params: [message, user, String]);
  }
}
