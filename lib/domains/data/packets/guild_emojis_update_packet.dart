import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildEmojisUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildEmojisUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildEmojisUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final EmojiManager emojiManager = EmojiManager.fromJson(marshaller, payload: message.payload['emojis'], roles: server.roles.list.values.toList());

    server.assets.emojis = emojiManager;

    dispatch(event: MineralEvent.serverEmojisUpdate, params: [emojiManager, server]);
  }
}
