import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.ready;

  final MemoryStorageContract storage;

  const ReadyPacket(this.storage);

  @override
  void listen(Map<String, dynamic> payload) {
    final { 'message': ShardMessage message, 'dispatch': Function(InternalEventParams) dispatch } = payload;

    final client = Bot.fromJson(message.payload);
    dispatch(InternalEventParams(event.toString(), [client]));
  }
}
