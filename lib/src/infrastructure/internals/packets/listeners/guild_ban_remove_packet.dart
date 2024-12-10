import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildBanRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildBanRemove;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server =
        await _dataStore.server.getServer(message.payload['guild_id']);
    final user =
        await _marshaller.serializers.user.serialize(message.payload['user']);

    dispatch(event: Event.serverBanRemove, params: [user, server]);
  }
}
