import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await _dataStore.server.getServer(payload['guild_id']);
    final threadRaw = await _marshaller.serializers.thread.normalize(payload);
    final thread = await _marshaller.serializers.thread.serialize(threadRaw);

    server.threads.add(thread);

    final serverRaw = await _marshaller.serializers.server.deserialize(server);
    final serverKey = _marshaller.cacheKey.server(server.id);

    _marshaller.cache.put(serverKey, serverRaw);

    final parentChannel =
        server.channels.list[Snowflake(thread.channelId)] as ServerTextChannel;
    parentChannel.threads.add(thread);

    final parentChannelRaw =
        await _marshaller.serializers.channels.deserialize(parentChannel);
    final parentChannelKey = _marshaller.cacheKey.channel(parentChannel.id);

    _marshaller.cache.put(parentChannelKey, parentChannelRaw);

    thread
      ..server = server
      ..parentChannel = parentChannel;

    dispatch(event: Event.serverThreadCreate, params: [thread, server]);
  }
}
