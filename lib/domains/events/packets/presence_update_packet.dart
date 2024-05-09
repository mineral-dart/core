import 'package:mineral/api/common/presence.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
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

    final before = server.members.list[message.payload['user']['id']];
    final member = server.members.list[message.payload['user']['id']];

    final presence = Presence.fromJson(message.payload);
    member!.presence = presence;

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverPresenceUpdate, params: [before, member, server]);
  }
}
