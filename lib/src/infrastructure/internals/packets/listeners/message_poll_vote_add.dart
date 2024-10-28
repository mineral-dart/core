import 'dart:convert';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class MessagePollVoteAdd implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messagePollVoteAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessagePollVoteAdd(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage shardMessage, DispatchEvent dispatch) async {
    print(jsonEncode(shardMessage.payload));
    final message = await marshaller.dataStore.message.getServerMessage(
      channelId: shardMessage.payload['channel_id'],
      messageId: shardMessage.payload['user_id'],
    );

    final member = marshaller.dataStore.member.getMember(
      serverId: shardMessage.payload['guild_id'],
      memberId: shardMessage.payload['user_id'],
    );

    dispatch(event: Event.serverPollVoteAdd, params: [message, member, String]);
  }
}
