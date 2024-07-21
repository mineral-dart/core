import 'package:mineral/api/common/presence.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class PresenceUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.presenceUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const PresenceUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final memberCacheKey = marshaller.cacheKey
        .serverMember(serverId: server.id, memberId: message.payload['user']['id']);

    final rawMember = await marshaller.cache.getOrFail(memberCacheKey);
    final member = await marshaller.serializers.member.serializeCache({
      ...rawMember,
      'guild_id': server.id.value,
    });

    final presence = Presence.fromJson(message.payload);
    member.presence = presence;

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverPresenceUpdate, params: [member, server, presence]);
  }
}
