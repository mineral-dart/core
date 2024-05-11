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
    final member = server.members.list[message.payload['user']['id']];
    final presence = Presence.fromJson(message.payload);
    final rawServer = await marshaller.serializers.server.deserialize(server);

    member?.presence = presence;
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: Event.serverPresenceUpdate, params: [member, server]);
  }
}