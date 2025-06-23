import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class InviteDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.inviteDelete;

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final code = message.payload['code'];
    final channel =
        await _datastore.channel.get(message.payload['channel_id'], false);

    dispatch(event: Event.inviteDelete, params: [code, channel]);
  }
}
