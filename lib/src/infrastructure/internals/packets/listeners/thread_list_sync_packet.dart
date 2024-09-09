import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ThreadListSyncPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadListSync;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadListSyncPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server =
        await marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadChannels = payload['threads'] as List<Map<String, dynamic>>;

    final threads = await threadChannels.map((element) async {
      final threadRaw = await marshaller.serializers.thread.normalize(element);
      return marshaller.serializers.thread.serialize(threadRaw);
    }).wait;

    dispatch(event: Event.serverThreadListSync, params: [threads, server]);
  }
}
