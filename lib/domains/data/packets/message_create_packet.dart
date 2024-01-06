import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.messageCreate;

  final MemoryStorageContract storage;

  const MessageCreatePacket(this.storage);

  @override
  void listen(Map<String, dynamic> payload) {
    final {'message': ShardMessage message, 'dispatch': Function(InternalEventParams) dispatch} =
        payload;

    switch (message.payload['guild_id']) {
      case String():
        sendServerMessage(dispatch, message.payload);
      default:
        throw 'Not implemented';
    }
  }

  void sendServerMessage(Function(InternalEventParams) dispatch, Map<String, dynamic> json) {
    final message = ServerMessage.fromJson(server: storage.servers[json['guild_id']]!, json: json);
    dispatch(InternalEventParams('ServerMessageEvent', [message]));
  }
}
