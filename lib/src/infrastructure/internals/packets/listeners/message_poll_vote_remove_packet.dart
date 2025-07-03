import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class MessagePollVoteRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messagePollVoteRemove;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload as Map<String, dynamic>;

    if (payload['guild_id'] != null) {
      await _server(payload, dispatch);
    } else {
      await _private(payload, dispatch);
    }
  }

  Future<void> _server(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(payload['guild_id'], false);
    final message = await _dataStore.message.get(payload['channel_id'], payload['message_id'], false);

    dispatch(event: Event.serverPollVoteRemove, params: [server, message, payload['answer_id']]);
  }

  Future<void> _private(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await _dataStore.message.get(payload['channel_id'], payload['message_id'], false);

    dispatch(event: Event.privatePollVoteRemove, params: [message, payload['answer_id']]);
  }
}
