import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class PresenceUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.presenceUpdate;

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final member = await _dataStore.member.get(
      message.payload['guild_id'],
      message.payload['user']['id'],
      false,
    );
    final presence = Presence.fromJson(message.payload);

    dispatch(event: Event.serverPresenceUpdate, params: [member, presence]);
  }
}
