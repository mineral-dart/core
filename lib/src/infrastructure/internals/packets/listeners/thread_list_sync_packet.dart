import 'package:mineral/container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ThreadListSyncPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadListSync;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server =
        await _marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadChannels = payload['threads'] as List<Map<String, dynamic>>;

    final threads = await threadChannels.map((element) async {
      final threadRaw = await _marshaller.serializers.thread.normalize(element);
      return _marshaller.serializers.thread.serialize(threadRaw);
    }).wait;

    dispatch(event: Event.serverThreadListSync, params: [threads, server]);
  }
}
