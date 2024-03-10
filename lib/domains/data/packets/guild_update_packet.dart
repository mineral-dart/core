import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final Snowflake serverId = Snowflake(message.payload['id']);

    final before = await marshaller.cache.get(serverId);
    final after = marshaller.serializers.server.serialize(message.payload);

    dispatch(event: MineralEvent.serverUpdate, params: [before, after]);

    marshaller.cache.put(serverId, message.payload);
  }
}
