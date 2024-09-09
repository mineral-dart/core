import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class PresenceUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.presenceUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const PresenceUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);
    final memberCacheKey =
        marshaller.cacheKey.member(server.id, message.payload['user']['id']);

    final member = await marshaller.dataStore.member.getMember(
        memberId: message.payload['user']['id'], serverId: server.id);

    final presence = Presence.fromJson(message.payload);
    member
      ..presence = presence
      ..server = server;

    final rawMember = await marshaller.serializers.member.deserialize(member);
    await marshaller.cache.put(memberCacheKey, rawMember);

    dispatch(
        event: Event.serverPresenceUpdate, params: [member, server, presence]);
  }
}