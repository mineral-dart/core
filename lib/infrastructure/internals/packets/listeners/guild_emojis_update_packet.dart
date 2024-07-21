import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildEmojisUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildEmojisUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildEmojisUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final serverCacheKey = marshaller.cacheKey.server(server.id);

    final EmojiManager emojiManager = EmojiManager.fromJson(marshaller,
        payload: message.payload['emojis'], roles: server.roles.list.values.toList());

    await emojiManager.list.values.map((emoji) async {
      final emojiCacheKey = marshaller.cacheKey.serverEmoji(serverId: server.id, emojiId: emoji.id!);
      return marshaller.cache.put(emojiCacheKey, emoji);
    }).wait;

    server.assets.emojis = emojiManager;

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverEmojisUpdate, params: [emojiManager, server]);
  }
}
