import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class PresenceUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.presenceUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final memberCacheKey =
        _marshaller.cacheKey.member(server.id.value, message.payload['user']['id']);

    final member =
        await _dataStore.member.get(server.id.value, message.payload['user']['id'], false);

    final presence = Presence.fromJson(message.payload);
    member
      ..presence = presence
      ..server = server;

    final rawMember = await _marshaller.serializers.member.deserialize(member);
    await _marshaller.cache.put(memberCacheKey, rawMember);

    dispatch(event: Event.serverPresenceUpdate, params: [member, server, presence]);
  }
}
