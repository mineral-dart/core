import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildStickersUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildStickersUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server =
        await _dataStore.server.get(message.payload['guild_id'], false);

    final stickers =
        await List.from(message.payload['stickers']).map((element) async {
      final raw = await _marshaller.serializers.sticker.normalize({
        'server_id': server.id,
        ...element,
      });

      return _marshaller.serializers.sticker.serialize(raw);
    }).wait;

    dispatch(event: Event.serverStickersUpdate, params: [
      server,
      stickers.asMap().map((_, value) => MapEntry(value.id, value))
    ]);
  }
}
