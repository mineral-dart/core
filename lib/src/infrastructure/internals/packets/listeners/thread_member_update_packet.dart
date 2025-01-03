import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadMemberUpdate;

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final thread = await _dataStore.channel.get(message.payload['id'], false);

    final member = await _dataStore.member.get(server.id.value, message.payload['user_id'], false);

    dispatch(event: Event.serverThreadMemberUpdate, params: [server, thread, member]);
  }
}
