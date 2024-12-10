import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/managers/sticker_manager.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
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
        await _dataStore.server.getServer(message.payload['guild_id']);

    final rawStickers =
        await List.from(message.payload['stickers']).map((element) async {
      return _marshaller.serializers.sticker.normalize({
        'server_id': server.id,
        ...element,
      });
    }).wait;

    final stickers = await List.from(rawStickers).map((element) async {
      return _marshaller.serializers.sticker.serialize(element);
    }).wait;

    final StickerManager stickerManager = StickerManager.fromList(stickers);

    server.assets.stickers = stickerManager;

    dispatch(
        event: Event.serverStickersUpdate, params: [stickerManager, server]);
  }
}
