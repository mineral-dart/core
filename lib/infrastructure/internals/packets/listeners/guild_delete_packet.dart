import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final cacheKey = marshaller.cacheKey.server(message.payload['id']);
    final server = await marshaller.dataStore.server.getServer(message.payload['id']);

    dispatch(event: Event.serverDelete, params: [server]);

    marshaller.cache.remove(cacheKey);
  }
}
