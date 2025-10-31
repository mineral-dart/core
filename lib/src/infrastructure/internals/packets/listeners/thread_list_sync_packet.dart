import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadListSyncPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadListSync;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await _dataStore.server.get(payload['guild_id'], false);
    final threadChannels = payload['threads'] as List<Map<String, dynamic>>;

    final threads = await threadChannels.map((element) async {
      final threadRaw = await _marshaller.serializers.channels.normalize(
        element,
      );
      return _marshaller.serializers.channels.serialize(threadRaw);
    }).wait;

    dispatch(event: Event.serverThreadListSync, params: [threads, server]);
  }
}
