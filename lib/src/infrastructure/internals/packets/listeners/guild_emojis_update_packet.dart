import 'package:mineral/container.dart';
import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildEmojisUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildEmojisUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server =
        await _dataStore.server.getServer(message.payload['guild_id']);
    final serverCacheKey = _marshaller.cacheKey.server(server.id);

    final rawEmojis = await List.from(message.payload['emojis'])
        .map((element) async =>
            _marshaller.serializers.emojis.normalize(element))
        .wait;

    final emojis = await rawEmojis.map((element) async {
      return _marshaller.serializers.emojis.serialize(element);
    }).wait;

    final EmojiManager emojiManager =
        EmojiManager.fromList(server.roles.list.values.toList(), emojis);

    server.assets.emojis = emojiManager;

    final rawServer = await _marshaller.serializers.server.deserialize(server);
    await _marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverEmojisUpdate, params: [emojiManager, server]);
  }
}
