import 'package:mineral/api/server/managers/sticker_manager.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildStickersUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildStickersUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildStickersUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final StickerManager stickerManager = StickerManager.fromJson(marshaller, message.payload['stickers']);

    server.assets.stickers = stickerManager;

    dispatch(event: Event.serverStickersUpdate, params: [stickerManager, server]);
  }
}
